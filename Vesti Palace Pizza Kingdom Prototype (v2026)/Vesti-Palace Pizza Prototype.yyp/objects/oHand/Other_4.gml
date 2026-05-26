if (held_item != noone) {
    if (instance_exists(held_item)) {
        held_item.held = false;
        held_item.depth = -100;

        if (variable_instance_exists(held_item, "base_xscale")) {
            held_item.image_xscale = held_item.base_xscale;
            held_item.image_yscale = held_item.base_yscale;
        }
    }
}

held_item = noone;
hover_target = noone;
cursor_state = 0;

global.hand_mode = HAND_MODE.GRAB;

input_lock_frames = 8;
await_mouse_release = true;