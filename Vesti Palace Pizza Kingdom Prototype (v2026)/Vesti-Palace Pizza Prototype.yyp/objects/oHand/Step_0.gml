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
// Paint mode — stamp toppings onto pizza
// --------------------------------------------------
// Paint mode
if (global.hand_mode == HAND_MODE.PAINT) {
    var pizza = instance_position(x, y, oPizzaV2);
    if (pizza != noone) {

        // Discrete toppings — one per click
		if (mouse_check_button_pressed(mb_left)) {
		    if (global.active_ingredient != INGREDIENT.SAUCE &&
		        global.active_ingredient != INGREDIENT.CHEESE) {
        
		        var dx = x - pizza.x;
		        var dy = y - pizza.y;
		        var pizza_radius_world = pizza.pizza_radius_surf * pizza.image_xscale;
        
		        if (dx*dx + dy*dy < pizza_radius_world * pizza_radius_world) {
            
		            // Count existing toppings of this type on this pizza
					var current_count = 0;
					var target_pizza = pizza;
					var target_ingredient = global.active_ingredient;
					with (oTopping) {
					    if (parent_pizza == target_pizza &&
					        ingredient_type == target_ingredient) {
					        current_count++;
					    }
}
            
		            // Check limit
		            var limit = 99;
		            switch (global.active_ingredient) {
		                case INGREDIENT.PEPPERONI: limit = pizza.max_pepperoni; break;
		                case INGREDIENT.MUSHROOM:  limit = pizza.max_mushroom;  break;
		                case INGREDIENT.GLASS:     limit = pizza.max_glass;     break;
		            }
            
		            if (current_count < limit) {
		                var t = instance_create_layer(x, y, "Instances", oTopping);
		                t.parent_pizza = pizza;
		                t.local_x = x - pizza.x;
		                t.local_y = y - pizza.y;
		                t.ingredient_type = global.active_ingredient;
		                switch (global.active_ingredient) {
		                    case INGREDIENT.MUSHROOM: t.variant = irandom(1); break;
		                    case INGREDIENT.GLASS:    t.variant = irandom(7); break;
		                    default: t.variant = 0; break;
		                }
		            }
		        }
		    }
		}

        // Sauce and cheese — stamp while held
       if (mouse_check_button(mb_left)) {
		    if (global.active_ingredient == INGREDIENT.SAUCE ||
		        global.active_ingredient == INGREDIENT.CHEESE) {

		        pizza.glob_timer++;
		        if (pizza.glob_timer >= pizza.glob_rate) {
		            pizza.glob_timer = 0;

		            if (global.active_ingredient == INGREDIENT.SAUCE) {
		                // Only paint if not already full
		                if (pizza.sauce_globs < pizza.sauce_target) {
		                    pizza.sauce_globs++;
		                    PizzaScripts(pizza, x, y, global.active_ingredient);
		                    var g = instance_create_layer(x, y, "Instances", oGlob);
		                    g.sprite_index = spr_sauce_brush;
		                }
		            } else {
		                if (pizza.cheese_globs < pizza.cheese_target) {
		                    pizza.cheese_globs++;
		                    PizzaScripts(pizza, x, y, global.active_ingredient);
		                    var g = instance_create_layer(x, y, "Instances", oGlob);
		                    g.sprite_index = spr_cheese_brush;
		                }
		            }
		        }
		    }
		}

        if (mouse_check_button_released(mb_left)) {
            pizza.glob_timer = 0;
        }
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