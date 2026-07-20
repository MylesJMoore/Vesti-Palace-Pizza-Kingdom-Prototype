// Visibility check
if !global.hud_visible exit;
for (var _i = 0; _i < array_length(hidden_rooms); _i++) {
    if room == hidden_rooms[_i] exit;
}
var _gw = display_get_gui_width();
var _pad = 30;
draw_set_font(fnt_dialogue);

// --- Slim HUD bar background ---
var _bar_bottom = 110;
draw_set_color(c_black);
draw_set_alpha(0.85);
draw_rectangle(0, hud_offset, _gw, _bar_bottom + hud_offset, false);
draw_set_color(c_white);
draw_set_alpha(0.25);
draw_line(0, _bar_bottom + hud_offset, _gw, _bar_bottom + hud_offset);
draw_set_alpha(1);

// --- Row 1: Name + Money (left) ---
var _row1_y = 16 + hud_offset;
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(_pad, _row1_y - 8, global.player_name);
draw_set_color(make_color_rgb(100, 255, 100));
draw_text(_pad + 220, _row1_y - 8, "$" + string(global.money));

// --- SCOOPS bar (slim, centered) ---
var _tier = clamp(floor(global.scoops / 100), 0, 7);
var _display_progress = clamp((display_scoops - _tier * 100) / 100, 0, 1);
var _bar_w = _gw * 0.4;               // CHANGED: smaller (tune 0.4)
var _bar_x = (_gw - _bar_w) * 0.5;    // CHANGED: centered
var _bar_y = 56 + hud_offset;
var _bar_h = 14;

// Above the bar — topping in AssemblyLineV2, rank+title everywhere else
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
if (room == AssemblyLineV2) {
    if (global.active_ingredient != INGREDIENT.NONE) {
        draw_set_color(scr_topping_color(global.active_ingredient));   // per-topping color
        draw_text(_gw * 0.5, _bar_y - 2, scr_topping_name(global.active_ingredient));
    } else if (global.pizza_ready) {
		idle_prompt = "ALL DONE!";
	} else {
        draw_set_color(make_color_rgb(160, 160, 160));
        draw_text(_gw * 0.5, _bar_y - 2, idle_prompt);                 // held random line
    }
} else {
    draw_set_color(scoops_colors[_tier]);
    draw_text(_gw * 0.5, _bar_y - 2, scoops_ranks[_tier] + "  " + scoops_titles[_tier]);
}

// Bar background
draw_set_color(make_color_rgb(20, 20, 20));
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);
// Bar fill — consistent gold progress
draw_set_color(make_color_rgb(255, 200, 40));
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w * _display_progress, _bar_y + _bar_h, false);
// Bar border
draw_set_color(c_white);
draw_set_alpha(0.6);
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, true);
draw_set_alpha(1);

// --- Below bar: SCOOPS count (left), Last grade (right) — pinned to screen edges ---
var _below_y = _bar_y + _bar_h + 6;
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(_pad, _below_y - 8, string(global.scoops) + " / 800");   // CHANGED: _pad, not _bar_x

// Last grade right, colored
var _grade_col = c_white;
switch (global.last_rank) {
    case "S+": case "S": _grade_col = make_color_rgb(255, 220, 50); break;
    case "A": _grade_col = make_color_rgb(100, 255, 100); break;
    case "B": _grade_col = make_color_rgb(100, 200, 255); break;
    case "C": _grade_col = make_color_rgb(200, 200, 200); break;
    case "D+": case "D": case "D-": _grade_col = make_color_rgb(255, 140, 0); break;
    case "F+": case "F": case "F-": _grade_col = make_color_rgb(255, 60, 60); break;
}
draw_set_halign(fa_right);
draw_set_color(_grade_col);
draw_text(_gw - _pad, _below_y - 8, "Last Pizza: " + global.last_rank);  // CHANGED: _gw - _pad

// --- Objective — centered ---
var _pulse = 0.7 + sin(current_time / 300) * 0.3;
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(make_color_rgb(255, 200, 40));
draw_set_alpha(_pulse);
draw_text(_gw * 0.5, _below_y - 8, hud_get_objective());

// Reset
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);