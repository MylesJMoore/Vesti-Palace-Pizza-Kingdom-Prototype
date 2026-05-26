function Pizza_FinalizeScore(pizza, order) {
    // order can be a struct later. For now, assume:
    // order.requires_sauce (bool)
    // order.requires_cheese (bool)
    // order.topping_counts_map (ds_map or struct)
    // etc.

    var accuracy = 100;

    // sauce requirement
    if (order.requires_sauce) {
        var ideal = 0.80;
        var diff = abs(pizza.sauce_coverage - ideal);
        accuracy -= clamp(diff * 120, 0, 40); // up to -40
    } else {
        if (pizza.sauce_coverage > 0.05) accuracy -= 15;
    }

    // cheese requirement
    if (order.requires_cheese) {
        var idealc = 0.85;
        var diffc = abs(pizza.cheese_coverage - idealc);
        accuracy -= clamp(diffc * 120, 0, 40);
    } else {
        if (pizza.cheese_coverage > 0.05) accuracy -= 15;
    }

    // burn penalty
    if (pizza.cook_state == PIZZA_COOK.BURNT) accuracy -= 35;
    if (pizza.cook_state == PIZZA_COOK.UNCOOKED) accuracy -= 20;

    // waste penalty (soft)
    var waste = pizza.metrics.waste_paints + pizza.metrics.waste_toppings;
    var waste_pen = clamp(waste * 0.02, 0, 20);
    accuracy -= waste_pen;

    accuracy = clamp(accuracy, 0, 100);

    // speed (placeholder)
    var elapsed_ms = current_time - pizza.metrics.start_time_ms;
    var pizzaspeed = 100 - clamp((elapsed_ms - 15000) / 300, 0, 60); // after 15s, start dropping

    // SLICE numeric
    var slice = round((accuracy * 0.7) + (pizzaspeed * 0.3));
    slice = clamp(slice, 0, 100);

    // Sonic-style rank
    var rank = "F";
    if (slice >= 60) rank = "C";
    if (slice >= 70) rank = "B";
    if (slice >= 80) rank = "A";
    if (slice >= 90) rank = "S";
    if (slice >= 97) rank = "S+";

    return {
        slice_score: slice,
        slice_rank: rank,
        accuracy: accuracy,
        pizzaspeed: pizzaspeed,
        waste: waste
    };
}