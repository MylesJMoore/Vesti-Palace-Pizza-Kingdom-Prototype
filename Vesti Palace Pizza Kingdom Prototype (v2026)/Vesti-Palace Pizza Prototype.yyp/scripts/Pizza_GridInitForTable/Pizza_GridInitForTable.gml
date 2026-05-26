function Pizza_GridInitForTable(table_id) {
    var table = table_id;
    var diameter = table.pizza_radius_px * 2;
    table.pizza.grid_cell = table.grid_cell_px;

    table.pizza.grid_w = ceil(diameter / table.grid_cell_px);
    table.pizza.grid_h = ceil(diameter / table.grid_cell_px);

    // inside mask + ingredient grids
    table.pizza.grid_inside = array_create(table.pizza.grid_w * table.pizza.grid_h, 0);
    table.pizza.grid_sauce  = array_create(table.pizza.grid_w * table.pizza.grid_h, 0);
    table.pizza.grid_cheese = array_create(table.pizza.grid_w * table.pizza.grid_h, 0);

    // mark inside pizza circle
    var circlex = (table.pizza.grid_w - 1) * 0.5;
    var circley = (table.pizza.grid_h - 1) * 0.5;
    var r_cells = (table.pizza_radius_px / table.grid_cell_px);

    for (var grid_y = 0; grid_y < table.pizza.grid_h; grid_y++) {
        for (var grid_x = 0; grid_x < table.pizza.grid_w; grid_x++) {
            var diameter_x = grid_x - circlex;
            var diameter_y = grid_y - circley;
            var inside = (diameter_x*diameter_x + diameter_y*diameter_y <= r_cells*r_cells);
            var idx = grid_x + grid_y * table.pizza.grid_w;
            table.pizza.grid_inside[idx] = inside ? 1 : 0;
        }
    }
}