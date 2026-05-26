//Parent
event_inherited();

// Variables
ingredient_type = INGREDIENT.NONE; // override per instance in room editor
is_selected = false;
can_be_picked_up = false;
can_be_clicked = true;
on_clicked = function() {
    if (is_selected) {
        // deselect
        is_selected = false;
        global.hand_mode = HAND_MODE.GRAB;
        global.active_ingredient = INGREDIENT.NONE;
    } else {
        // deselect any other bin first
        with (oBin) { is_selected = false; }
        is_selected = true;
        global.hand_mode = HAND_MODE.PAINT;
        global.active_ingredient = ingredient_type;
    }
};