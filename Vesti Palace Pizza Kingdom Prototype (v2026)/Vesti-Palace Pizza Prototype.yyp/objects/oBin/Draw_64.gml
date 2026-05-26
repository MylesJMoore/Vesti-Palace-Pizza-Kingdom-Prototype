// TESTING
draw_set_color(c_white);
draw_text(24, 460, "Active Ingredient: " + string(global.active_ingredient));
draw_text(24, 480, "Hand Mode: " + string(global.hand_mode));
draw_text(24, 500, "Toppings alive: " + string(instance_number(oTopping)));