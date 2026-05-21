function Pizza_StampTopping(table, pizza, px, py) {
    if (!PointInPizza(pizza, px, py)) {
        pizza.metrics.waste_toppings += 1;
        return;
    }

    var dx = px - table.last_stamp_x;
    var dy = py - table.last_stamp_y;

    if (dx * dx + dy * dy < table.stamp_spacing_px * table.stamp_spacing_px) return;

    table.last_stamp_x = px;
    table.last_stamp_y = py;

    var topping_struct = {
        type: table.active_ingredient,
        x: px,
        y: py,
        cook_state: pizza.cook_state,
        variant: 0
    };

    if (table.active_ingredient == INGREDIENT.MUSHROOM) {
        topping_struct.variant = irandom(1);
    }

    if (table.active_ingredient == INGREDIENT.GLASS) {
        topping_struct.variant = irandom(7);
    }

    ds_list_add(pizza.toppings, topping_struct);
}