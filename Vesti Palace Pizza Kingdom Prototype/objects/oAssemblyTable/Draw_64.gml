draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var debug_x = 24;
var debug_y = 24;
var line_h = 20;

draw_text(debug_x, debug_y + line_h * 0, "Active Ingredient: " + string(active_ingredient));
draw_text(debug_x, debug_y + line_h * 1, "Paint Mode: " + string(global.hand_mode));

if (current_pizza != noone) {
    draw_text(debug_x, debug_y + line_h * 2, "Cook State: " + string(current_pizza.cook_state));
    draw_text(debug_x, debug_y + line_h * 3, "Sauce: " + string_format(current_pizza.sauce_coverage * 100, 0, 1) + "%");
    draw_text(debug_x, debug_y + line_h * 4, "Cheese: " + string_format(current_pizza.cheese_coverage * 100, 0, 1) + "%");
    draw_text(debug_x, debug_y + line_h * 5, "Toppings: " + string(ds_list_size(current_pizza.toppings)));
} else {
    draw_text(debug_x, debug_y + line_h * 2, "No pizza on table");
}

var p = instance_find(oPizza, 0);
if (instance_exists(p)) {
    draw_text(debug_x, debug_y + line_h * 7, "Pizza X: " + string(round(p.x)));
    draw_text(debug_x, debug_y + line_h * 8, "Pizza Y: " + string(round(p.y)));
    draw_text(debug_x, debug_y + line_h * 9, "Table X: " + string(round(x)));
    draw_text(debug_x, debug_y + line_h * 10, "Table Y: " + string(round(y)));
	draw_text(debug_x, debug_y + line_h * 11, "Bounds mode: " + string(p.drag_bounds_mode));
}