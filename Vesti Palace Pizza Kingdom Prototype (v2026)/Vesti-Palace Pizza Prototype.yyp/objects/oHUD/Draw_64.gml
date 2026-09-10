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
var _bar_w = _gw * 0.4;
var _bar_x = (_gw - _bar_w) * 0.5;
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
        draw_set_color(make_color_rgb(100, 255, 100));
        draw_text(_gw * 0.5, _bar_y - 2, "ALL DONE!");                 // draw directly, keep idle_prompt intact
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
draw_text(_pad, _below_y - 8, string(global.scoops) + " / 800");

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
draw_text(_gw - _pad, _below_y - 8, "Last Pizza: " + global.last_rank);

// Day counter — top row, right edge, same baseline as name
draw_set_font(fnt_dialogue);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(_gw - _pad, _row1_y - 8, "Day " + string(global.day_number));

// --- Objective — centered ---
var _pulse = 0.7 + sin(current_time / 300) * 0.3;
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(make_color_rgb(255, 200, 40));
draw_set_alpha(_pulse);
draw_text(_gw * 0.5, _below_y - 8, hud_get_objective());
draw_set_alpha(1);

// --- Current order ticket (assembly + counter) ---
if (room == AssemblyLineV2 || room == CounterCustomer) {
    draw_set_font(fnt_dialogue);
    var _px = 30;
    var _py = 120 + hud_offset;
    var _text_pad = 16;
    var _line_h   = 26;
    var _header_h = 34;

    if (!global.order_revealed) {
        // Hidden until the player talks to the customer
        var _hint = "Talk to the customer for their order!";
        var _pw = string_width(_hint) + _text_pad * 2;
        var _ph = _header_h + _line_h + 12;
        draw_set_color(make_color_rgb(250, 248, 240));
        draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
        draw_set_color(make_color_rgb(200, 45, 45));
        draw_rectangle(_px, _py, _px + _pw, _py + _header_h, false);
        draw_set_color(c_white);
        draw_set_halign(fa_left); draw_set_valign(fa_middle);
        draw_text(_px + _text_pad, _py + _header_h * 0.5, "ORDER  -  ???");
        draw_set_color(make_color_rgb(90, 90, 90));
        draw_text(_px + _text_pad, _py + _header_h + _line_h * 0.5, _hint);
        draw_set_color(make_color_rgb(180, 60, 60));
        draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);
        draw_set_halign(fa_left); draw_set_valign(fa_top); draw_set_color(c_white);
    } else {
        var _pz   = (room == AssemblyLineV2) ? instance_find(oPizzaV2, 0) : noone;
        var _live = (_pz != noone && instance_exists(_pz));

        var _rows = [];   // each: { text, status }  status: 0 todo / 1 done / 2 bad

        // Sauce
		if (global.current_order[INGREDIENT.SAUCE] > 0) {
		    array_push(_rows, { text: "Vesti Sauce",
		        status: (_live && _pz.sauce_globs >= SAUCE_FULL * SAUCE_IDEAL) ? 1 : 0 });
		} else {
		    array_push(_rows, { text: "NO Sauce",
		        status: (_live && _pz.sauce_globs > 0) ? 2 : 1 });
		}
		// Cheese
		if (global.current_order[INGREDIENT.CHEESE] > 0) {
		    array_push(_rows, { text: "Cheese",
		        status: (_live && _pz.cheese_globs >= CHEESE_FULL * CHEESE_IDEAL) ? 1 : 0 });
		} else {
		    array_push(_rows, { text: "NO Cheese",
		        status: (_live && _pz.cheese_globs > 0) ? 2 : 1 });
		}
        // Toppings — remaining count
        var _pool = scr_orderable_ingredients();
        for (var _i = 0; _i < array_length(_pool); _i++) {
            var _ing  = _pool[_i];
            var _want = global.current_order[_ing];
            if (_want <= 0) continue;
            var _have   = _live ? _pz.topping_counts[_ing] : 0;
            var _remain = _want - _have;
            var _nm     = scr_topping_name(_ing);
            if (_remain > 0)        array_push(_rows, { text: _nm + "  x" + string(_remain), status: 0 });
            else if (_have > _want) array_push(_rows, { text: _nm + "  TOO MANY!",           status: 2 });
            else                    array_push(_rows, { text: _nm + "  x0",                  status: 1 });
        }
        if (array_length(_rows) == 0) array_push(_rows, { text: "Just the base!", status: 0 });

        // Measure widest line
        var _title = "ORDER  -  " + scr_customer_name(global.current_customer);
        var _maxw = string_width(_title);
        for (var _i = 0; _i < array_length(_rows); _i++) _maxw = max(_maxw, string_width(_rows[_i].text));
        var _pw = _maxw + _text_pad * 2;
        var _ph = _header_h + array_length(_rows) * _line_h + 12;

        // Paper + header
        draw_set_color(make_color_rgb(250, 248, 240));
        draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
        draw_set_color(make_color_rgb(200, 45, 45));
        draw_rectangle(_px, _py, _px + _pw, _py + _header_h, false);
        draw_set_color(c_white);
        draw_set_halign(fa_left); draw_set_valign(fa_middle);
        draw_text(_px + _text_pad, _py + _header_h * 0.5, _title);

        // Rows, colored by status
        var _iy = _py + _header_h;
        for (var _i = 0; _i < array_length(_rows); _i++) {
            var _rc;
            switch (_rows[_i].status) {
                case 1:  _rc = make_color_rgb(90, 180, 90); break;   // done
                case 2:  _rc = make_color_rgb(210, 60, 60); break;   // bad
                default: _rc = make_color_rgb(35, 35, 35);  break;   // todo
            }
            draw_set_color(_rc);
            draw_text(_px + _text_pad, _iy + _line_h * 0.5, _rows[_i].text);
            draw_set_color(make_color_rgb(224, 170, 170));
            draw_line(_px + 8, _iy + _line_h, _px + _pw - 8, _iy + _line_h);
            _iy += _line_h;
        }

        draw_set_color(make_color_rgb(180, 60, 60));
        draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);
        draw_set_halign(fa_left); draw_set_valign(fa_top); draw_set_color(c_white);
    }
}

// Reset
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);