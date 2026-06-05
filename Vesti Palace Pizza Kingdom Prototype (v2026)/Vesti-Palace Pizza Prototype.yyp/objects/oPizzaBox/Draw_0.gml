// Draw shadow when held
if held {
    draw_sprite_ext(sprite_index, 0,
        x + 4, y + 6,
        image_xscale * 0.98, image_yscale * 0.98,
        0, c_black, 0.35);
}
draw_self();

// Draw "snap here" hint when open and pizza is nearby
if box_state == "open" {
    var pizza = instance_find(oPizzaV2, 0);
    if instance_exists(pizza) {
        var dx = pizza.x - x;
        var dy = pizza.y - y;
        if dx*dx + dy*dy < (snap_radius * 1.5) * (snap_radius * 1.5) {
            draw_set_color(c_white);
            draw_set_alpha(0.3);
            draw_circle(x, y, snap_radius * image_xscale, true);
            draw_set_alpha(1);
        }
    }
}