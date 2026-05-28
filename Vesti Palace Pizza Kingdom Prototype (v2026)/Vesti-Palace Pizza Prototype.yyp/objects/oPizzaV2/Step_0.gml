event_inherited();

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