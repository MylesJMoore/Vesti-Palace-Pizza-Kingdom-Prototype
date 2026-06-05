if has_pizza {
    reset_timer++;
    
    if reset_timer == 60 {
        var _box = instance_find(oPizzaBox, 0);
        if instance_exists(_box) instance_destroy(_box);
        
        var _scorer = instance_find(oSliceScore, 0);
        if instance_exists(_scorer) {
            _scorer.show_timer    = 0;
            _scorer.show_continue = false;
            _scorer.active        = true;
        }
    }
    
    if reset_timer > 60 {
        var _scorer = instance_find(oSliceScore, 0);
        if instance_exists(_scorer) && _scorer.show_continue {
            if mouse_check_button_pressed(mb_left) {
                global.pizza_ready       = false;
                global.pizza_sauce       = 0;
                global.pizza_cheese      = 0;
                global.pizza_cook        = 0;
                global.pizza_toppings    = 0;
                global.topping_depth     = 0;
                global.hand_mode         = HAND_MODE.GRAB;
                global.active_ingredient = INGREDIENT.NONE;
                
                global.current_customer++;
                if global.current_customer >= array_length(global.customer_queue) {
                    global.current_customer = 0;
                }
                
                room_goto(VestiPalace);
            }
        }
    }
    exit;
}