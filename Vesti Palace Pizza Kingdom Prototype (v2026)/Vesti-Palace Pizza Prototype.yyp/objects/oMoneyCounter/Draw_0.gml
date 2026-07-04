draw_self();

// Drop zone circle
var _pulse = 1 + sin(current_time / 400) * 0.05;
draw_set_color(make_color_rgb(100, 255, 100));
draw_set_alpha(0.15);
draw_circle(x, y, drop_radius * _pulse, false);
draw_set_alpha(0.5);
draw_circle(x, y, drop_radius * _pulse, true);
draw_set_alpha(1);

// Floating +$X popups
draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
for (var _i = 0; _i < array_length(popups); _i++) {
    var _p = popups[_i];
    var _a = _p.life / _p.max_life;
    draw_set_color(make_color_rgb(100, 255, 100));
    draw_set_alpha(_a);
    draw_text_transformed(_p.x, _p.y, "+$" + string(_p.val), 1.3, 1.3, 0);
}
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);