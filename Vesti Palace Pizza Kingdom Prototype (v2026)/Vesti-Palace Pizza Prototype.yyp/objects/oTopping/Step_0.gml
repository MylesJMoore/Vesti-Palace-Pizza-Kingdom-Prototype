event_inherited();

if (instance_exists(parent_pizza)) {
    x = parent_pizza.x + local_x;
    y = parent_pizza.y + local_y;
    
    if (parent_pizza.held) {
        depth = -99995;
    }
}