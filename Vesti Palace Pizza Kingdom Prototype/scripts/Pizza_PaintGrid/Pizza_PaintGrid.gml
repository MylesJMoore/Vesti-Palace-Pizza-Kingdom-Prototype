function Pizza_PaintGrid(table_id, px, py, radius_px, which) {
    var t = table_id;

    // convert world point to grid coords (0..w-1, 0..h-1)
    // grid origin is top-left of pizza bounding box
    var left = t.pizza_center_x - t.pizza_radius_px;
    var top  = t.pizza_center_y - t.pizza_radius_px;

    var gx_center = (px - left) / t.pizza.grid_cell;
    var gy_center = (py - top)  / t.pizza.grid_cell;

    var r_cells = radius_px / t.pizza.grid_cell;

    // iterate a small square region around brush
    var gx0 = floor(gx_center - r_cells);
    var gx1 = ceil (gx_center + r_cells);
    var gy0 = floor(gy_center - r_cells);
    var gy1 = ceil (gy_center + r_cells);

    for (var gy = gy0; gy <= gy1; gy++) {
        if (gy < 0 || gy >= t.pizza.grid_h) continue;

        for (var gx = gx0; gx <= gx1; gx++) {
            if (gx < 0 || gx >= t.pizza.grid_w) continue;

            var dx = gx - gx_center;
            var dy = gy - gy_center;

            if (dx*dx + dy*dy > r_cells*r_cells) continue;

            var idx = gx + gy * t.pizza.grid_w;

            // only count inside pizza circle
            if (t.pizza.grid_inside[idx] == 0) {
                t.pizza.metrics.waste_paints += 1;
                continue;
            }

            if (which == "sauce") t.pizza.grid_sauce[idx] = 1;
            if (which == "cheese") t.pizza.grid_cheese[idx] = 1;
        }
    }

    // update coverage
    t.pizza.sauce_coverage = Pizza_CoverageFromGrid(t.pizza.grid_sauce, t.pizza.grid_inside);
    t.pizza.cheese_coverage = Pizza_CoverageFromGrid(t.pizza.grid_cheese, t.pizza.grid_inside);
}