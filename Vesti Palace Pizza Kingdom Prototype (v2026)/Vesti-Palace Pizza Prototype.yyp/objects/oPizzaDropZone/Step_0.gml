if has_pizza exit;

// Delivery Zone Flash
pulse_phase += 0.05;
flash_alpha = 1;
flash_radius = drop_radius;

if flash_alpha > 0 {
    flash_alpha -= 0.03;
    flash_radius += 4;
    if flash_alpha < 0 flash_alpha = 0;
}

// Delivery Calculation
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
        
        var _scorer = instance_find(oSliceScore, 0);
        if instance_exists(_scorer) {
            _scorer.slice_score   = _result.slice_score;
            _scorer.display_score = 0;
            _scorer.rank          = _result.rank;
            _scorer.fade_alpha    = 1;
            _scorer.active        = false;
        }
        
        // Signal oCustomerDelivery to start the score sequence
        var _delivery = instance_find(oCustomerDelivery, 0);
        if instance_exists(_delivery) {
            _delivery.has_pizza = true;
        }
    }
}