if held {
    draw_sprite_ext(sprite_index, 0,
        x + 4, y + 6,
        image_xscale * 0.98, image_yscale * 0.98,
        0, c_black, 0.35);
}
draw_self();

if box_state == "open" && glow_intensity > 0 {
    var _pulse = 1 + sin(hint_pulse) * 0.15;
    var _r = (snap_radius * image_xscale) * _pulse;
    
    // Spotlight glow scales with intensity
    draw_set_color(c_yellow);
    draw_set_alpha(0.06 * glow_intensity);
    draw_circle(x, y, _r * 2.2, false);
    draw_set_alpha(0.1 * glow_intensity);
    draw_circle(x, y, _r * 1.5, false);

    // Soft fill
    draw_set_color(c_lime);
    draw_set_alpha(0.12 * glow_intensity);
    draw_circle(x, y, _r, false);

    // Pulsing outline
    draw_set_color(c_lime);
    draw_set_alpha((0.5 + sin(hint_pulse) * 0.3) * glow_intensity);
    draw_circle(x, y, _r, true);

    draw_set_alpha(1);
}