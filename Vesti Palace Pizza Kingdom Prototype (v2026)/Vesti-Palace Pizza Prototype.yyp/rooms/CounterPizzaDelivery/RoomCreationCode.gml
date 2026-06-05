if global.pizza_ready {
    var box = instance_create_layer(669, 693, "Instances", oPizzaBox);
    box.box_state = "closed";
    box.sprite_index = spr_pizza_box_closed;
    box.can_be_picked_up = true;
    box.can_be_clicked = false;
}

// Safe debug
var _b = instance_find(oPizzaBox, 0);
show_debug_message("pizza_ready: " + string(global.pizza_ready));
show_debug_message("box exists: " + string(instance_exists(_b)));
show_debug_message("counter depth: " + string(obj_counter.depth));
show_debug_message("customer depth: " + string(oCustomerDelivery.depth));