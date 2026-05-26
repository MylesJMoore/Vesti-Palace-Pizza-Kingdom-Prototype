function Pizza_CoverageFromGrid(grid, inside_mask) {
    var total = 0;
    var filled = 0;
    var n = array_length(inside_mask);

    for (var i = 0; i < n; i++) {
        if (inside_mask[i] == 1) {
            total += 1;
            if (grid[i] == 1) filled += 1;
        }
    }

    if (total <= 0) return 0;
    return filled / total;
}