event_inherited();
drag_bounds_mode = 0;
can_be_picked_up = true;
can_be_clicked = false;
is_locked = false;

// Visual state
cook_state = PIZZA_COOK.UNCOOKED;
image_xscale = 0.5;
image_yscale = 0.5;

// Coverage tracking (simple glob counting)
sauce_globs = 0;
cheese_globs = 0;
sauce_target = 20; // globs needed for "full" coverage
cheese_target = 20;

// Sprite
sprite_index = spr_base_uncooked;