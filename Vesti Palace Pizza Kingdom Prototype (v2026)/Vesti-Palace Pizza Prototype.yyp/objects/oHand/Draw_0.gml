// Screen shake — offset the cursor draw position
var _shake_x = 0;
var _shake_y = 0;
if shake_timer > 0 {
    shake_timer--;
    var _falloff = shake_timer / shake_duration;
    _shake_x = random_range(-shake_intensity, shake_intensity) * _falloff;
    _shake_y = random_range(-shake_intensity, shake_intensity) * _falloff;
}

var spr = spr_cursor_default;

if (global.hand_mode == HAND_MODE.PAINT) {
    switch (global.active_ingredient) {
        case INGREDIENT.SAUCE:  spr = spr_sauce_brush;  break;
        case INGREDIENT.CHEESE: spr = spr_cheese_brush; break;
        default: spr = spr_cursor_default; break;
    }
} else {
    switch (cursor_state) {
        case 1: spr = spr_cursor_hover;  break;
        case 2: spr = spr_cursor_click;  break;
        default: spr = spr_cursor_default; break;
    }
}

draw_sprite(spr, 0, x, y);