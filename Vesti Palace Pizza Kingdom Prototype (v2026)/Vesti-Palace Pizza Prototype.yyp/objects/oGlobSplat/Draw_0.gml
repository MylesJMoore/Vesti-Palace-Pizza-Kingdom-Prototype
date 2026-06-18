var _alpha = life / max_life;
draw_set_color(col);
draw_set_alpha(_alpha);
draw_circle(x, y, size * _alpha, false);
draw_set_alpha(1);