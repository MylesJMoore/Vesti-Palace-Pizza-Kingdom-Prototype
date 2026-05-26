function Pizza_Create() {
    var pizza = {
        cook_state: PIZZA_COOK.UNCOOKED,

        sauce_coverage: 0,
        cheese_coverage: 0,

        // grid coverage maps (inside-pizza cells only)
        grid_w: 0,
        grid_h: 0,
        grid_cell: 0,
        grid_inside: undefined,
        grid_sauce: undefined,
        grid_cheese: undefined,

        // toppings are stamped pieces with cook variants
        toppings: ds_list_create(), // list of structs {type, x, y, cook_state, variant}

        // metrics for SLICE (Phase 1 used lightly, Phase 2 will love it)
        metrics: {
            start_time_ms: current_time,
            actions: 0,
            waste_paints: 0,
            waste_toppings: 0,
            mistakes: 0
        }
    };

    return pizza;
}