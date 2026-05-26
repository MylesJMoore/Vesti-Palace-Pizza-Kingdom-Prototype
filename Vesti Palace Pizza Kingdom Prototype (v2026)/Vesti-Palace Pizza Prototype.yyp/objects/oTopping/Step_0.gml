event_inherited();

// anchor to pizza every frame
if (instance_exists(parent_pizza)) {
    x = parent_pizza.x + local_x;
    y = parent_pizza.y + local_y;
}