event_inherited();
// Physics
drag_strength = 0.16;
max_speed     = 12;
drag_friction_x = 0.50;
drag_friction_y = 0.50;
slide = 0.72;

// Settings
drag_bounds_mode = 0;
can_be_picked_up = true;
can_be_clicked = false;
is_locked = false;
cook_state = PIZZA_COOK.UNCOOKED;

// Sprites
depth = -100;
image_xscale = 0.3;
image_yscale = 0.3;
sprite_index = spr_base_uncooked;

// Coverage
sauce_globs = 0;
cheese_globs = 0;
sauce_target = 400;
cheese_target = 400;

// Toppings Limit
max_pepperoni = 99;
max_mushroom  = 99;
max_glass     = 99;

// Glob stamp timer
glob_timer = 0;
glob_rate = 2;

//Surface
//Surf Size is the internal resolution of the paint surface
//Pizza radius is for the painting area radius in the shape of a circle
surface_offset_x = 0;
surface_offset_y = 10;
surf_sauce  = -1;
surf_cheese = -1;
surf_size = 1500;
pizza_radius_surf = 435;

//Squish
squish_timer = 0;