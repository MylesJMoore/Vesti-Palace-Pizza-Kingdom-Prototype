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

draw_self();