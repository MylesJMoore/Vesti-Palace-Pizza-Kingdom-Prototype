draw_self();

if (is_selected) {
    draw_set_color(c_yellow);
    draw_set_alpha(0.4);
    draw_rectangle(
        x - sprite_width/2, y - sprite_height/2,
        x + sprite_width/2, y + sprite_height/2,
        false
    );
    draw_set_alpha(1);
    draw_set_color(c_white);
}