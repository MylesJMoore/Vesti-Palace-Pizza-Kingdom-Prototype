x = oPizzaV2.x;
y = oPizzaV2.y;
depth = oPizzaV2.depth - 1;

// Squish on drop
if oPizzaV2.squish_timer > 0 {
    oPizzaV2.squish_timer--;
    var _t = oPizzaV2.squish_timer / 12;
    image_xscale = lerp(0.3, 0.3 * 1.3, _t);
    image_yscale = lerp(0.3, 0.3 * 0.7, _t);
} else {
    image_xscale = 0.3;
    image_yscale = 0.3;
}