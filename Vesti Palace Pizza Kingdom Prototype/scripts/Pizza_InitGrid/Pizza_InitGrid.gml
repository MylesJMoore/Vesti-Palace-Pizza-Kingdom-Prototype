function Pizza_InitGrid(pizza) {
    var diameter = pizza.pizza_radius_px * 2;

    pizza.grid_w = ceil(diameter / pizza.grid_cell);
    pizza.grid_h = ceil(diameter / pizza.grid_cell);

    pizza.grid_inside = array_create(pizza.grid_w * pizza.grid_h, 0);
    pizza.grid_sauce  = array_create(pizza.grid_w * pizza.grid_h, 0);
    pizza.grid_cheese = array_create(pizza.grid_w * pizza.grid_h, 0);

    var cx = (pizza.grid_w - 1) * 0.5;
    var cy = (pizza.grid_h - 1) * 0.5;
    var r_cells = pizza.pizza_radius_px / pizza.grid_cell;

    for (var gy = 0; gy < pizza.grid_h; gy++) {
        for (var gx = 0; gx < pizza.grid_w; gx++) {
            var dx = gx - cx;
            var dy = gy - cy;
            var idx = gx + gy * pizza.grid_w;

            if (dx * dx + dy * dy <= r_cells * r_cells) {
                pizza.grid_inside[idx] = 1;
            }
        }
    }
}