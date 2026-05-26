if (has_pizza) {
    var elapsed = current_time - cook_start_time;

    if (elapsed >= burn_time) {
        pizza_in.cook_state = PIZZA_COOK.BURNT;
    }
    else if (elapsed >= cook_time_needed) {
        pizza_in.cook_state = PIZZA_COOK.COOKED;
    }
    else {
        pizza_in.cook_state = PIZZA_COOK.UNCOOKED;
    }
}