// TESTING
draw_set_color(c_white);
draw_text(24, 460, "Active Ingredient: " + string(global.active_ingredient));
draw_text(24, 480, "Hand Mode: " + string(global.hand_mode));
draw_text(24, 500, "Toppings alive: " + string(instance_number(oTopping)));

var p = instance_find(oPizzaV2, 0);
if (instance_exists(p)) {
    var sauce_pct = clamp(p.sauce_globs / p.sauce_target, 0, 1) * 100;
    var cheese_pct = clamp(p.cheese_globs / p.cheese_target, 0, 1) * 100;
    draw_text(24, 520, "Sauce: " + string(round(sauce_pct)) + "%  (" + string(p.sauce_globs) + " globs)");
    draw_text(24, 540, "Cheese: " + string(round(cheese_pct)) + "% (" + string(p.cheese_globs) + " globs)");
	draw_text(24, 560, "Pizza depth: " + string(p.depth));
    draw_text(24, 580, "Pizza held: " + string(p.held));
}


var t = instance_find(oTopping, 0);
if (instance_exists(t)) {
    draw_text(24, 600, "Topping depth: " + string(t.depth));
}
draw_text(24, 620, "Hand depth: " + string(oHand.depth));
