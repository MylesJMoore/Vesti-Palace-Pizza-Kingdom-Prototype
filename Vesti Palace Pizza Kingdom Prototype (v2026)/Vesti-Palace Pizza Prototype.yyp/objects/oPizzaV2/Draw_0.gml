var px = x;
var py = y;
var sx = image_xscale;
var sy = image_yscale;
var draw_x = px - (surf_size * sx * 0.5) - surface_offset_x;
var draw_y = py - (surf_size * sy * 0.5) - surface_offset_y;

// Pick sauce sprite based on cook state
var spr_sauce = spr_sauce_uncooked;
var spr_chees = spr_cheese_uncooked;
if (cook_state == PIZZA_COOK.COOKED) {
    spr_sauce = spr_sauce_cooked;
    spr_chees = spr_cheese_cooked;
}
if (cook_state == PIZZA_COOK.BURNT) {
    spr_sauce = spr_sauce_burnt;
    spr_chees = spr_cheese_burnt;
}

// Base
var spr_base = spr_base_uncooked;
if (cook_state == PIZZA_COOK.COOKED) spr_base = spr_base_cooked;
if (cook_state == PIZZA_COOK.BURNT)  spr_base = spr_base_burnt;

draw_sprite_ext(spr_base, 0, px, py, sx, sy, 0, c_white, 1);

// Sauce surface — now using cooked sprite as tint color source
if (surface_exists(surf_sauce)) {
    draw_surface_ext(surf_sauce, draw_x, draw_y, sx, sy, 0, c_white, 1);
}

// Cheese surface
if (surface_exists(surf_cheese)) {
    draw_surface_ext(surf_cheese, draw_x, draw_y, sx, sy, 0, c_white, 1);
}