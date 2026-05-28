event_inherited();
// Physics
drag_strength = 0.16;
max_speed     = 18;
drag_friction_x = 0.80;
drag_friction_y = 0.80;
slide = 0.92;

// Settings
drag_bounds_mode = 0;
can_be_picked_up = true;
can_be_clicked = false;
is_locked = false;
cook_state = PIZZA_COOK.UNCOOKED;

// Sprites
image_xscale = 0.3;
image_yscale = 0.3;
sprite_index = spr_base_uncooked;

// Coverage
sauce_globs = 0;
cheese_globs = 0;
sauce_target = 100;
cheese_target = 100;

// Toppings Limit
max_pepperoni = 8;
max_mushroom  = 10;
max_glass     = 8;

// Glob stamp timer
glob_timer = 0;
glob_rate = 2;

//Surface
//Surf Size is the internal resolution of the paint surface
//Pizza radius is for the painting area radius in the shape of a circle
surface_offset_x = 20;
surface_offset_y = 20;
surf_sauce  = -1;
surf_cheese = -1;
surf_size   = 1100;
pizza_radius_surf = 475;