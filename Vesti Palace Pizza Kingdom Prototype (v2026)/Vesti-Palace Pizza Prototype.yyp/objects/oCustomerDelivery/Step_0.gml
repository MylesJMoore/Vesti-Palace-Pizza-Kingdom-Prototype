//Customer Sprite
sprite_index = global.current_customer_sprite;

// Customer Idle Bob
bob_phase += bob_speed;
y = base_y + sin(bob_phase) * bob_amount;

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
				
				//Reset HUD Idle Prompts in Assembly Line
				oHUD.idle_prompt = scr_topping_prompt();
                
                global.current_customer++;
                if global.current_customer >= array_length(global.customer_queue) {
                    global.current_customer = 0;
                }
                
				//Check if we finished the Day then rotate to the next Customer
				if (scr_day_should_close()) {
				    room_goto(DayEndTally);
				    // no scr_customer_new() here — scr_day_next() rolls the next day's customer
				} else {
				    scr_customer_new();
				    room_goto(VestiPalace);
				}
            }
        }
    }
    exit;
}