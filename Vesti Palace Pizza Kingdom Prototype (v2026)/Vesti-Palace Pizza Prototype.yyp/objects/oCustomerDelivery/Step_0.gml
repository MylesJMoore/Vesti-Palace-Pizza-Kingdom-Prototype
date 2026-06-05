if has_pizza {
    reset_timer++;
    show_debug_message("reset_timer: " + string(reset_timer) + " scorer active: " + string(instance_find(oSliceScore, 0) != noone ? instance_find(oSliceScore, 0).active : "noone"));
    // Phase 1 — brief pause before showing score (60 frames)
    if reset_timer == 60 {
        // Destroy the pizza box
        var _box = instance_find(oPizzaBox, 0);
        if instance_exists(_box) instance_destroy(_box);
        
        // Activate scorer
        var _scorer = instance_find(oSliceScore, 0);
        if instance_exists(_scorer) {
            _scorer.active = true;
        }
    }
    
    // Phase 3 — reset after score display
    if reset_timer >= reset_delay {
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
        
        room_goto(AssemblyLineV2);
    }
    exit;
}

// Check for pizza box drop
var box = instance_find(oPizzaBox, 0);
if instance_exists(box) && !box.held && box.box_state == "closed" {
    var dx = box.x - x;
    var dy = box.y - y;
    if dx*dx + dy*dy < drop_radius * drop_radius {
        has_pizza = true;
        box.can_be_picked_up = false;
        
        var _result = Pizza_CalcSlice(
            global.pizza_sauce,
            global.pizza_cheese,
            global.pizza_cook,
            global.pizza_toppings
        );
        
        // Pre-load scorer but don't activate yet
        var _scorer = instance_find(oSliceScore, 0);
        if instance_exists(_scorer) {
            _scorer.slice_score   = _result.slice_score;
            _scorer.display_score = 0;
            _scorer.rank          = _result.rank;
            _scorer.display_timer = 180;
            _scorer.fade_alpha    = 1;
            _scorer.active        = false; // activated at frame 60
        }
    }
}