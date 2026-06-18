event_inherited();

if (instance_exists(parent_pizza)) {
    x = parent_pizza.x + local_x;
    y = parent_pizza.y + local_y;
    
    if (parent_pizza.held) {
        depth = -99995;
    }
}

// Squish on land
if squish_timer > 0 {
    squish_timer--;
    var _t = squish_timer / 10;
    image_xscale = lerp(base_xscale, base_xscale * 1.4, _t);
    image_yscale = lerp(base_yscale, base_yscale * 0.6, _t);
} else {
    image_xscale = base_xscale;
    image_yscale = base_yscale;
}