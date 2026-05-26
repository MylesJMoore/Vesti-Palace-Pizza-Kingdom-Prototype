// CONFIG
pizza_radius_px = 140;
pizza_center_x = x;
pizza_center_y = y;

paint_radius_px = 22;
stamp_spacing_px = 18;

table_half_w = 800;
table_half_h = 120;

active_ingredient = INGREDIENT.NONE;

// sprite references
base_sprite_uncooked   = spr_base_uncooked;
base_sprite_cooked     = spr_base_cooked;
base_sprite_burnt      = spr_base_burnt;

sauce_sprite_uncooked  = spr_sauce_uncooked;
sauce_sprite_cooked    = spr_sauce_cooked;
sauce_sprite_burnt     = spr_sauce_burnt;

cheese_sprite_uncooked = spr_cheese_uncooked;
cheese_sprite_cooked   = spr_cheese_cooked;
cheese_sprite_burnt    = spr_cheese_burnt;

// runtime refs
current_pizza = noone;

// painting tracking
is_painting = false;
last_stamp_x = -99999;
last_stamp_y = -99999;

pizza = noone;