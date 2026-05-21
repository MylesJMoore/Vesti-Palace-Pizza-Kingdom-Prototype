function PointInPizza(pizza, px, py) {
    var dx = px - pizza.x;
    var dy = py - pizza.y;
    return (dx * dx + dy * dy <= pizza.pizza_radius_px * pizza.pizza_radius_px);
}