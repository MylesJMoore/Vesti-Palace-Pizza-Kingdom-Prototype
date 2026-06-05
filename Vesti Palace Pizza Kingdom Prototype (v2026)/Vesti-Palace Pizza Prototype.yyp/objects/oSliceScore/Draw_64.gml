if !active exit;

draw_set_color(c_red);
draw_text(100, 100, "SCORER DRAW RUNNING active:" + string(active));

var _cx = display_get_gui_width() * 0.5;
var _cy = display_get_gui_height() * 0.5;

draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Dark overlay
draw_set_color(c_black);
draw_set_alpha(0.6 * fade_alpha);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// SLICE label
draw_set_color(c_yellow);
draw_set_alpha(fade_alpha);
draw_text_transformed(_cx, _cy - 140, "S.L.I.C.E", 1, 1, 0);

// Rolling score number
draw_set_color(c_white);
draw_set_alpha(fade_alpha);
draw_text_transformed(_cx, _cy - 60, string(floor(display_score)), 1.5, 1.5, 0);

// Big rank letter — slams in
var _rank_color = c_white;
switch (rank) {
    case "S+": _rank_color = make_color_rgb(255, 220, 50);  break;
    case "S":  _rank_color = make_color_rgb(255, 220, 50);  break;
    case "A":  _rank_color = make_color_rgb(100, 255, 100); break;
    case "B":  _rank_color = make_color_rgb(100, 200, 255); break;
    case "C":  _rank_color = make_color_rgb(200, 200, 200); break;
    case "F":  _rank_color = make_color_rgb(255, 80, 80);   break;
}
draw_set_color(_rank_color);
draw_set_alpha(fade_alpha);
draw_text_transformed(_cx, _cy + 60, rank, rank_scale * 4, rank_scale * 4, 0);

// Continue hint
if display_timer < 120 {
    draw_set_color(c_white);
    draw_set_alpha(fade_alpha * 0.6);
    draw_text_transformed(_cx, _cy + 180, "click to continue", 1, 1, 0);
}

draw_set_alpha(1);
draw_set_halign(fa_left);