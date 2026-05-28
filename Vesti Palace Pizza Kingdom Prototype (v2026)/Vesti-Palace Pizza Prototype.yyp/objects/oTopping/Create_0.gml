event_inherited();
spawn_id = instance_number(oTopping);
parent_pizza = noone;
local_x = 0;
local_y = 0;
ingredient_type = INGREDIENT.NONE;
cook_state = PIZZA_COOK.UNCOOKED;
variant = 0;
can_be_picked_up = true;
can_be_clicked = false;
drag_bounds_mode = 0;

// Random variant on spawn
variant = irandom(1); // for mushroom L/R
// glass and others override this in oHand when spawning

image_xscale = 0.3;
image_yscale = 0.3;
image_angle = random(360); // random starting rotation for fun