event_inherited();

image_xscale = 0.5;
image_yscale = 0.5;

// Tub behavior
can_be_picked_up = false;
can_be_clicked = true;

// Default (will be overridden per instance or child)
ingredient_type = INGREDIENT.NONE;

// Optional: for visual feedback later
is_selected = false;

// Click callback
on_clicked = Tub_OnClicked;