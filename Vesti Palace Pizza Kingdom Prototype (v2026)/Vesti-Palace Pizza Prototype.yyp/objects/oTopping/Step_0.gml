event_inherited();

if (instance_exists(parent_pizza)) {
    x = parent_pizza.x + local_x;
    y = parent_pizza.y + local_y;
    depth = parent_pizza.depth - 1 - spawn_id;
}