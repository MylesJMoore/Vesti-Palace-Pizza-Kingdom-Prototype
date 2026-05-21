event_inherited();

drag_bounds_mode = 2;

image_xscale = 0.5;
image_yscale = 0.5;

cook_state = PIZZA_COOK.UNCOOKED;

sauce_coverage = 0;
cheese_coverage = 0;

grid_cell = 12;
pizza_radius_px = 140;

grid_w = 0;
grid_h = 0;
grid_inside = [];
grid_sauce = [];
grid_cheese = [];

toppings = ds_list_create();

metrics = {
    start_time_ms: current_time,
    actions: 0,
    waste_paints: 0,
    waste_toppings: 0,
    mistakes: 0
};

Pizza_InitGrid(id);