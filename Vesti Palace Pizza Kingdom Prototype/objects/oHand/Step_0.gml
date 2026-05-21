// --------------------------------------------------
// Position hand in room space
// --------------------------------------------------
x = mouse_x;
y = mouse_y;

// Drain lock frames ONLY when mouse is already up
// This prevents frames from expiring while mouse is still held
if (input_lock_frames > 0) {
    if (!mouse_check_button(mb_left)) {
        input_lock_frames -= 1;
    }
    exit;
}

// Once frames are drained, still require a clean release
// (covers the case where mouse came UP during the lock window)
if (await_mouse_release) {
    if (!mouse_check_button(mb_left)) {
        await_mouse_release = false;
    }
    exit;
}


// --------------------------------------------------
// Hover detection
// Only detect hover if not already holding something
// --------------------------------------------------
if (held_item == noone) {
    hover_target = instance_position(x, y, oInteractable);
} else {
    hover_target = noone;
}

// --------------------------------------------------
// Pick up / click
// --------------------------------------------------
if (mouse_check_button_pressed(mb_left)) {
    if (held_item == noone && hover_target != noone) {

        // Click-only object (ex: tubs)
        if (!hover_target.can_be_picked_up && hover_target.can_be_clicked) {
            if (is_callable(hover_target.on_clicked)) {
                hover_target.on_clicked(hover_target);
            }
        }
        // Draggable object only in GRAB mode
        else if (global.hand_mode == HAND_MODE.GRAB && hover_target.can_be_picked_up) {
            held_item = hover_target;
            held_item.held = true;

            // Keep relative grab point so item doesn't snap to center
            held_item.hold_offset_x = held_item.x - x;
            held_item.hold_offset_y = held_item.y - y;

            // bring held item above most things
            held_item.depth = -99999;

            // store original scale safely
            held_item.base_xscale = held_item.image_xscale;
            held_item.base_yscale = held_item.image_yscale;

            // enlarge slightly while holding
            //held_item.image_xscale = held_item.base_xscale + .7;
            //held_item.image_yscale = held_item.base_yscale + .7;
        }
    }
}

// --------------------------------------------------
// While holding, apply follow force (inertia)
// --------------------------------------------------
if (held_item != noone) {
    if (!instance_exists(held_item)) {
        held_item = noone;
    } else {
        var tx = x + held_item.hold_offset_x;
        var ty = y + held_item.hold_offset_y;

        var half_itemw = held_item.sprite_width * 0.5;
        var half_itemh = held_item.sprite_height * 0.5;

        switch (held_item.drag_bounds_mode) {
            case 0:
                // no target clamping
                break;

            case 1:
                // counter bounds
                tx = clamp(tx, global.counter_min_x + half_itemw, global.counter_max_x - half_itemw);
                ty = clamp(ty, global.counter_min_y + half_itemh, global.counter_max_y - half_itemh);
                break;

            case 2:
                // full room bounds
                tx = clamp(tx, half_itemw, room_width - half_itemw);
                ty = clamp(ty, half_itemh, room_height - half_itemh);
                break;
        }

        held_item.vx += (tx - held_item.x) * held_item.drag_strength;
        held_item.vy += (ty - held_item.y) * held_item.drag_strength;

        held_item.vx = clamp(held_item.vx, -held_item.max_speed, held_item.max_speed);
        held_item.vy = clamp(held_item.vy, -held_item.max_speed, held_item.max_speed);
    }
}

// --------------------------------------------------
// Drop
// --------------------------------------------------
if (mouse_check_button_released(mb_left)) {
    if (held_item != noone) {
        if (instance_exists(held_item)) {
            var dropped = held_item;

            // restore original scale
            if (variable_instance_exists(dropped, "base_xscale")) {
                dropped.image_xscale = dropped.base_xscale;
                dropped.image_yscale = dropped.base_yscale;
            }

            dropped.held = false;
            dropped.depth = -100;
        }

        held_item = noone;
    }
}

// --------------------------------------------------
// Right click cancels paint mode
// --------------------------------------------------
if (mouse_check_button_pressed(mb_right)) {
    global.hand_mode = HAND_MODE.GRAB;

    var table = instance_find(oAssemblyTable, 0);
    if (instance_exists(table)) {
        table.active_ingredient = INGREDIENT.NONE;
        table.is_painting = false;
    }
}

// --------------------------------------------------
// Decide cursor state
// click has priority
// --------------------------------------------------
if (mouse_check_button(mb_left)) {
    cursor_state = 2;
} else if (hover_target != noone) {
    cursor_state = 1;
} else {
    cursor_state = 0;
}