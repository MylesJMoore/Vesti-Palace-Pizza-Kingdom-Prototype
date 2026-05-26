//Drop Shadow only when held
if (held) {
    draw_sprite_ext(
        sprite_index, image_index,
        x + 4, y + 6,
        image_xscale * 0.98, image_yscale * 0.98,
        image_angle,
        c_black,
        0.35
    );
}

draw_set_color(c_yellow);
draw_text(24, 300, "counter_min_x: " + string(global.counter_min_x));
draw_text(24, 320, "counter_min_y: " + string(global.counter_min_y));
draw_text(24, 340, "counter_max_x: " + string(global.counter_max_x));
draw_text(24, 360, "counter_max_y: " + string(global.counter_max_y));


draw_set_color(c_red);
draw_set_alpha(0.4);
draw_rectangle(global.counter_min_x, global.counter_min_y, global.counter_max_x, global.counter_max_y, true);
draw_set_alpha(1);

draw_self();
