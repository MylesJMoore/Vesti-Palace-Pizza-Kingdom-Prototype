// Position Cursor
var w = sprite_get_width(spr_default);
var h = sprite_get_height(spr_default);
var hw = w * 0.5;
var hh = h * 0.5;
x = clamp(mouse_x, hw, room_width - hw);  //Clamping by half size
y = clamp(mouse_y, hh, room_height - hh); //Clamping by half size

// Hover detection (only if not already holding something)
if (held_item == noone) {
    hover_target = instance_position(x, y, oInteractable);
} else {
    hover_target = noone;
}

// Pick up
if (mouse_check_button_pressed(mb_left)) {
    if (held_item == noone && hover_target != noone) {
        held_item = hover_target;
        held_item.held = true;

        // Keep relative grab point so it doesn't "jump" to center
        held_item.hold_offset_x = held_item.x - x;
        held_item.hold_offset_y = held_item.y - y;

        // bring held item above most things
        held_item.depth = -99999;
    }
}

// While holding, apply follow force (inertia)
if (held_item != noone) {

    var tx = x + held_item.hold_offset_x;
    var ty = y + held_item.hold_offset_y;

    var half_itemw = held_item.sprite_width  * 0.5;
    var half_itemh = held_item.sprite_height * 0.5;

    // Clamp target based on the held item's bounds mode
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

// Drop
if (mouse_check_button_released(mb_left)) {
    if (held_item != noone) {
		if(held_item.clickable_main_menu_start) {
			room_goto(VestiPalace);
		}
        var dropped = held_item;   // cache reference before clearing
        dropped.held = false;
		dropped.depth = -100;
        held_item = noone;
    }
}

// Decide cursor state (click has priority)
if (mouse_check_button(mb_left)) {
    cursor_state = 2;
} else if (hover_target != noone) {
    cursor_state = 1;
} else {
    cursor_state = 0;
}
