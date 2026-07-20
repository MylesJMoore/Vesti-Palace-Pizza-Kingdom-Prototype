/// @function scr_topping_name(id)
function scr_topping_name(_id) {
    switch (_id) {
        case INGREDIENT.NONE:		return "None";
		case INGREDIENT.SPECIALSAUCE:		return "Special Sauce";
		case INGREDIENT.SAUCE:		return "Vesti Pizza Sauce";
        case INGREDIENT.CHEESE:		return "Cheese";
        case INGREDIENT.PEPPERONI:  return "Pepperoni";
        case INGREDIENT.MUSHROOM:   return "Mushroom";
        case INGREDIENT.GLASS:      return "Glass Shard";
        default:				    return noone;
    }
}

/// @function scr_topping_icon(id)
/// @description Small HUD icon.
function scr_topping_icon(_id) {
    switch (_id) {
        case INGREDIENT.NONE:		return noone;
		case INGREDIENT.SAUCE:		return spr_sauce_brush;
		case INGREDIENT.SPECIALSAUCE:		return spr_specialsauce_brush;
        case INGREDIENT.CHEESE:		return spr_cheese_brush;
        case INGREDIENT.PEPPERONI:  return spr_pepperoni_brush;
        case INGREDIENT.MUSHROOM:   return spr_mushroom_brush;
        case INGREDIENT.GLASS:      return spr_glass_brush;
        default:				    return noone;
    }
}

/// @function scr_topping_color(id)
/// @description Text color per topping for HUD + labels.
function scr_topping_color(_id) {
    switch (_id) {
        case INGREDIENT.SAUCE:      return make_color_rgb(230, 60, 50);    // red
		case INGREDIENT.SPECIALSAUCE:      return make_color_rgb(110, 220, 110);    // green
        case INGREDIENT.CHEESE:     return make_color_rgb(255, 210, 60);   // yellow
        case INGREDIENT.PEPPERONI:  return make_color_rgb(255, 140, 30);   // orange
        case INGREDIENT.MUSHROOM:   return make_color_rgb(110, 220, 110);  // green
        case INGREDIENT.GLASS:      return make_color_rgb(140, 210, 255);  // light blue
        default:                    return c_white;
    }
}

/// @function scr_topping_prompt()
/// @description Random "pick a topping" flavor text. No args.
function scr_topping_prompt() {
    static _lines = [
        "Pick a topping ya loser!",
        "The pizza won't make itself.",
        "Hello?? Empty Pizza calling.",
        "A bare pizza is a sad pizza.",
        "Pick a bin, chef.",
        "Toppings go on Pizza. Get to it.",
        "Empty pizza detected. Fix it.",
        "Grab a topping ya dork!",
        "We don't serve blank pies here.",
        "Click a bin, you beautiful fool.",
    ];
    return _lines[irandom(array_length(_lines) - 1)];
}

/// @function scr_topping_cost(id)
function scr_topping_cost(_id) {
    switch (_id) {
        case INGREDIENT.SAUCE:      return 0;    // base layers free
		case INGREDIENT.SPECIALSAUCE:      return 0;
        case INGREDIENT.CHEESE:     return 0;	 // base layers free
        case INGREDIENT.PEPPERONI:  return 1;
        case INGREDIENT.MUSHROOM:   return 2;
        case INGREDIENT.GLASS:      return 5;
        default:                    return 0;
    }
}

/// @function scr_money_popup(x, y, amount)
function scr_money_popup(_x, _y, _amount) {
    var _p = instance_create_layer(_x, _y, "Instances", oMoneyPopup); // any layer that draws in-world
    if (_amount < 0) {
        _p.txt = "-$" + string(abs(_amount));
        _p.col = make_color_rgb(255, 80, 80);
    } else if (_amount > 0) {
        _p.txt = "+$" + string(_amount);
        _p.col = make_color_rgb(100, 255, 100);
    } else {
        _p.txt = "Can't afford!";
        _p.col = make_color_rgb(255, 200, 40);
    }
    return _p;
}