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
	spr = scr_topping_icon(global.active_ingredient);
} else {
    switch (cursor_state) {
        case 1: spr = spr_cursor_hover;  break;
        case 2: spr = spr_cursor_click;  break;
        default: spr = spr_cursor_default; break;
    }
}

draw_sprite(spr, 0, x, y);

//Toppings Text
var _bin = instance_position(mouse_x, mouse_y, oBin);
if (_bin != noone) {
    // Show label if this bin is the selected one, OR nothing is selected yet
    if (_bin.is_selected || global.active_ingredient == INGREDIENT.NONE) {
        var _name = scr_topping_name(_bin.ingredient_type); // the BIN's ingredient, not the global
        var _ty = y - (sprite_exists(sprite_index) ? sprite_height * 0.5 : 0) - 8;
        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        // shadow
        draw_set_color(c_black);
        draw_text(x + 1, _ty + 1, _name);
        // fill — per-topping color, matches the HUD
        draw_set_color(scr_topping_color(_bin.ingredient_type));
        draw_text(x, _ty, _name);
        // reset
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
    }
}