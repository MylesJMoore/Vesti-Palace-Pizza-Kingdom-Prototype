event_inherited();

can_be_picked_up = false;
can_be_clicked = true;
drag_bounds_mode = 0;
depth = -99980; // above pizza surfaces, below toppings
image_xscale = 0.3;
image_yscale = 0.3;

// States: "open", "closed"
box_state = "open";

// Reference to pizza inside
pizza_ref = noone;

// Snap detection radius in world px
snap_radius = 100;

sprite_index = spr_pizza_box_open; // swap for your open box sprite