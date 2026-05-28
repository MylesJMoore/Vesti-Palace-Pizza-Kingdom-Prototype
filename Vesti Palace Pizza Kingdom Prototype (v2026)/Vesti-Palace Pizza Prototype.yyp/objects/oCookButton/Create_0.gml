event_inherited();
can_be_picked_up = false;
can_be_clicked = true;
held = false;
cook_stage = 0;
on_clicked = function(self_ref) {
    var pizza = instance_find(oPizzaV2, 0);
    if (!instance_exists(pizza)) exit;
    
    self_ref.cook_stage++;
    if (self_ref.cook_stage > 2) self_ref.cook_stage = 2;
    
    pizza.cook_state = self_ref.cook_stage;
    Pizza_Cook(pizza);
};