event_inherited();

// Squish on drop
if squish_timer > 0 {
    squish_timer--;
    var _t = squish_timer / 12;
    image_xscale = lerp(0.3, 0.3 * 1.3, _t);
    image_yscale = lerp(0.3, 0.3 * 0.7, _t);
} else {
    image_xscale = 0.3;
    image_yscale = 0.3;
}

// Lock in place while painting
if (global.hand_mode == HAND_MODE.PAINT) {
    vx = 0;
    vy = 0;
}

// Recreate surfaces if lost (happens on window focus loss)
if (!surface_exists(surf_sauce)) {
    surf_sauce = surface_create(surf_size, surf_size);
    surface_set_target(surf_sauce);
    draw_clear_alpha(c_white, 0);
    surface_reset_target();
}
if (!surface_exists(surf_cheese)) {
    surf_cheese = surface_create(surf_size, surf_size);
    surface_set_target(surf_cheese);
    draw_clear_alpha(c_white, 0);
    surface_reset_target();
}