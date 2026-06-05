event_inherited();

// Always stay above counter when closed
if box_state == "closed" && !held && room == CounterPizzaDelivery {
    depth = -200;
}

if box_state == "open" && !held {
    var pizza = instance_find(oPizzaV2, 0);
    if instance_exists(pizza) {
        var dx = pizza.x - x;
        var dy = pizza.y - y;
        
        if !pizza.held {
            if dx*dx + dy*dy < snap_radius * snap_radius {
                pizza.x = x;
                pizza.y = y;
                pizza.vx = 0;
                pizza.vy = 0;
                pizza_ref = pizza;
                pizza.can_be_picked_up = false;
                pizza.can_be_clicked = false;
                
                // Auto close
                box_state = "closed";
                sprite_index = spr_pizza_box_closed;
                depth = -99997;
                can_be_picked_up = true;
                can_be_clicked = false;
                
                // Store score data
                global.pizza_sauce    = pizza.sauce_globs;
                global.pizza_cheese   = pizza.cheese_globs;
                global.pizza_cook     = pizza.cook_state;
                global.pizza_toppings = instance_number(oTopping);
                global.pizza_ready    = true;
            }
        }
    }
}