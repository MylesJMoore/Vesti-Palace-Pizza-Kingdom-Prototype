/// @function scr_order_new()
function scr_order_new() {
    var _o = array_create(INGREDIENT.COUNT, 0);

    // Base layers: explicit yes/no (0 = customer does NOT want it → penalized if present)
    _o[INGREDIENT.SAUCE]  = (random(1) < 0.75) ? 1 : 0;
    _o[INGREDIENT.CHEESE] = (random(1) < 0.75) ? 1 : 0;

    // Toppings
    var _pool  = scr_orderable_ingredients();
    var _types = irandom_range(1, array_length(_pool));
    var _copy  = array_create(array_length(_pool));
    array_copy(_copy, 0, _pool, 0, array_length(_pool));
    repeat (_types) {
        var _i   = irandom(array_length(_copy) - 1);
        var _ing = _copy[_i];
        if (random(1) < 0.15) _o[_ing] = irandom_range(10, 15);
        else                  _o[_ing] = irandom_range(5, 8);
        array_delete(_copy, _i, 1);
    }

    // Guarantee at least one positive requirement (no fully-empty "no everything" order)
    var _positive = (_o[INGREDIENT.SAUCE] > 0) || (_o[INGREDIENT.CHEESE] > 0);
    for (var _k = 0; _k < array_length(_pool); _k++) if (_o[_pool[_k]] > 0) _positive = true;
    if (!_positive) _o[INGREDIENT.SAUCE] = 1;

    return _o;
}

/// @function scr_customer_new()
/// @description Rotate to a new customer (never the same one twice in a row) + generate their order.
function scr_customer_new() {
    // Pick a new customer that isn't the one who just left
    var _prev = global.current_customer;
    var _next = _prev;
    if (CUSTOMER.COUNT > 1) {          // guard so it can't loop forever with only one customer
        do {
            _next = irandom(CUSTOMER.COUNT - 1);
        } until (_next != _prev);
    }
    global.current_customer = _next;

    global.current_customer_sprite = scr_customer_sprite(global.current_customer);
    global.current_order    = scr_order_new();
    global.order_served     = false;
    global.order_revealed   = false;   // hide the new order until they talk

    // Reset counter dialogue — guard for init order (manager isn't built yet at game start)
    if (instance_exists(obj_dialogue_manager)
        && variable_instance_exists(obj_dialogue_manager, "flags")
        && is_struct(obj_dialogue_manager.flags)) {
        dialogue_set_flag("met_counter_customer", false);
    }

    // NOTE: the with(oNPC) triggered_auto reset is no longer needed — the counter
    // now fires on arrival (was_in_range), not the triggered_auto latch. Safe to delete.
    with (oNPC) {
        if (npc_id == "counter_customer") {
            triggered_auto      = false;
            dialogue_was_active = false;
        }
    }
}

function scr_customer_name(_id) {
    switch (_id) {
        case CUSTOMER.GURAMAHSH: return "Guramahsh";
        case CUSTOMER.SCARY_GUY: return "Nice Scary Guy";
        case CUSTOMER.POET:      return "Tortured Hungry Poet";
        case CUSTOMER.FRANK:     return "Frank";
        case CUSTOMER.DR_YELLOW: return "Dr. Yellow Guy";
        case CUSTOMER.MRS_CLOUD: return "Mrs. Cloud";
        default:                 return "Customer";
    }
}

function scr_customer_sprite(_id) {
    switch (_id) {
        case CUSTOMER.GURAMAHSH: return spr_guramahsh;
        case CUSTOMER.SCARY_GUY: return spr_scary_guy;
        case CUSTOMER.POET:      return spr_poet;
        case CUSTOMER.FRANK:     return spr_frank;
        case CUSTOMER.DR_YELLOW: return spr_dr_yellow_guy;
        case CUSTOMER.MRS_CLOUD: return spr_mrs_cloud;
        default:                 return spr_default_npc;
    }
}

/// @function scr_customer_greet_node(id)
/// @description Which dialogue node this customer greets with.
function scr_customer_greet_node(_id) {
    switch (_id) {
        case CUSTOMER.GURAMAHSH: return "greet_guramahsh";
        case CUSTOMER.SCARY_GUY: return "greet_scary";
        case CUSTOMER.POET:      return "greet_poet";
        case CUSTOMER.FRANK:     return "greet_frank";
        case CUSTOMER.DR_YELLOW: return "greet_dryellow";
        case CUSTOMER.MRS_CLOUD: return "greet_cloud";
        default:                 return "greet_guramahsh";
    }
}

function scr_customer_satisfaction_lines(_satisfaction_score) {
    var _satisfaction_line = "has no opinions.";
    if _satisfaction_score >= 97      _satisfaction_line = "LOVES your perfect order!";
    else if _satisfaction_score >= 90 _satisfaction_line = "LOVED your almost perfect order!";
    else if _satisfaction_score >= 80 _satisfaction_line = "REALLY LIKED your order!";
    else if _satisfaction_score >= 70 _satisfaction_line = "LIKED your order.";
    else if _satisfaction_score >= 60 _satisfaction_line = "KINDA NOT REALLY LIKED your order.";
    else if _satisfaction_score >= 50 _satisfaction_line = "THINKS your order sucks.";
    else if _satisfaction_score >= 40 _satisfaction_line = "WONDERS if you know how to make pizza.";
    else if _satisfaction_score >= 30 _satisfaction_line = "THINKS you suck and this pizza sucks.";
    else if _satisfaction_score >= 20 _satisfaction_line = "HATES THIS ORDER.";
    else if _satisfaction_score >= 10 _satisfaction_line = "THINKS YOU NEED TO GET A NEW JOB.";
	
	return _satisfaction_line;
}

/// @function scr_order_to_text(order)
/// @description Human-readable order string, e.g. "Pepperoni x3, Mushroom x1"
function scr_order_to_text(_order) {
    var _lines = scr_order_lines(_order);
    var _str = "";
    for (var _i = 0; _i < array_length(_lines); _i++) {
        if (_str != "") _str += ", ";
        _str += _lines[_i];
    }
    return _str;
}

// @function scr_order_lines(order)
/// @description Array of display strings, one per requirement.
function scr_order_lines(_order) {
    var _lines = [];
    if (_order[INGREDIENT.SAUCE]  > 0) array_push(_lines, "Vesti Sauce");
    if (_order[INGREDIENT.CHEESE] > 0) array_push(_lines, "Cheese");

    var _pool = scr_orderable_ingredients();
    for (var _i = 0; _i < array_length(_pool); _i++) {
        var _ing = _pool[_i];
        if (_order[_ing] > 0) {
            array_push(_lines, scr_topping_name(_ing) + "  x" + string(_order[_ing]));
        }
    }
    if (array_length(_lines) == 0) array_push(_lines, "Just the base!");
    return _lines;
}

/// @function scr_orderable_ingredients()
/// @description The toppings that can be ordered/graded. Add additional ones here later.
function scr_orderable_ingredients() {
    return [INGREDIENT.PEPPERONI, INGREDIENT.MUSHROOM, INGREDIENT.GLASS];
}