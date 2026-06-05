if global.pizza_ready {
    var box = instance_create_layer(800, 448, "Instances", oPizzaBox);
    box.box_state = "closed";
    box.sprite_index = spr_pizza_box_closed;
    box.can_be_picked_up = true;
    box.can_be_clicked = false;
}

show_debug_message("pizza: " + string(oPizzaBox.depth) + " counter: " + string(obj_counter.depth) + " customer: " + string(oCustomerDelivery.depth));