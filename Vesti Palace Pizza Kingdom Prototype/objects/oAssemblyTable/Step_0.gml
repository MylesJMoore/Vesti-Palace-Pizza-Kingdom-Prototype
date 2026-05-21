current_pizza = noone;
// find a pizza near the table center
with (oPizza) {
    if (
        x > other.x - other.table_half_w &&
        x < other.x + other.table_half_w &&
        y > other.y - other.table_half_h &&
        y < other.y + other.table_half_h
    ) {
        other.current_pizza = id;
        other.pizza = id;
    }
}

if (current_pizza != noone) {
    pizza_center_x = current_pizza.x;
    pizza_center_y = current_pizza.y;
}

if (global.hand_mode != HAND_MODE.PAINT) {
    is_painting = false;
    exit;
}
if (current_pizza == noone) {
    is_painting = false;
    exit;
}
var mx = mouse_x;
var my = mouse_y;
var m_down = mouse_check_button(mb_left);
var m_pressed = mouse_check_button_pressed(mb_left);
var m_released = mouse_check_button_released(mb_left);
// start painting
if (m_pressed && PointInPizza(current_pizza, mx, my)) {
    is_painting = true;
    current_pizza.metrics.actions += 1;
}
// stop painting
if (m_released) {
    is_painting = false;
}
// active paint
if (is_painting && m_down) {
    if (active_ingredient == INGREDIENT.SAUCE) {
        Pizza_PaintGrid(id, mx, my, paint_radius_px, "sauce");
    }
    else if (active_ingredient == INGREDIENT.CHEESE) {
        Pizza_PaintGrid(id, mx, my, paint_radius_px, "cheese");
    }
    else if (
        active_ingredient == INGREDIENT.PEPPERONI ||
        active_ingredient == INGREDIENT.MUSHROOM ||
        active_ingredient == INGREDIENT.GLASS
    ) {
        Pizza_StampTopping(id, current_pizza, mx, my);
    }
}