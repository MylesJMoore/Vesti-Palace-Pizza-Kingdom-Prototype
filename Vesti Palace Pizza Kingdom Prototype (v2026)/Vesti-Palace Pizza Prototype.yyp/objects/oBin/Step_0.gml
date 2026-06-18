event_inherited();

if pulse_timer > 0 {
    pulse_timer--;
    var _t = pulse_timer / 8;
    image_xscale = lerp(base_xscale, base_xscale * 1.2, _t);
    image_yscale = lerp(base_yscale, base_yscale * 1.2, _t);
} else {
    image_xscale = base_xscale;
    image_yscale = base_yscale;
}