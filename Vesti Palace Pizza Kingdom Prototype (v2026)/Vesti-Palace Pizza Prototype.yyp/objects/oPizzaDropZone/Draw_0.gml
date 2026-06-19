var _pulse = 1 + sin(pulse_phase) * 0.08;
var _r = drop_radius * _pulse;

draw_set_color(c_yellow);
draw_set_alpha(0.15);
draw_circle(x, y, _r, false);
draw_set_alpha(0.5 + sin(pulse_phase) * 0.2);
draw_circle(x, y, _r, true);
draw_set_alpha(1);