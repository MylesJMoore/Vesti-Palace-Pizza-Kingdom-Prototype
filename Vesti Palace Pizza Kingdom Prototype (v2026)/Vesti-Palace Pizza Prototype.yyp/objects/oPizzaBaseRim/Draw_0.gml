// Base
var px = x;
var py = y;
var sx = image_xscale;
var sy = image_yscale;
var spr_base = spr_base_uncooked_rim;
if (oPizzaV2.cook_state == PIZZA_COOK.COOKED) spr_base = spr_base_cooked_rim;
if (oPizzaV2.cook_state == PIZZA_COOK.BURNT)  spr_base = spr_base_burnt_rim;

draw_sprite_ext(spr_base, 0, px, py, sx, sy, 0, c_white, 1);