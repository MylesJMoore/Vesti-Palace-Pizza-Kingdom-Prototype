var _a = clamp(life / 45, 0, 1);   // fade out
draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(_a);
draw_set_color(c_black);
draw_text(x + 1, y + 1, txt);
draw_set_color(col);
draw_text(x, y, txt);
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);