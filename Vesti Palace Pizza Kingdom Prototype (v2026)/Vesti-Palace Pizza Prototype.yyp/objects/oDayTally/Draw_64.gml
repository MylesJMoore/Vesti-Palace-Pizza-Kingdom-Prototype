/// oDayTally — Draw GUI
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// dim backdrop (full screen)
draw_set_alpha(0.85);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

// palette
var _ink    = make_color_rgb(35, 35, 35);
var _green  = make_color_rgb(30, 150, 30);    // money
var _yellow = make_color_rgb(190, 145, 0);    // scoops
var _blue   = make_color_rgb(40, 120, 210);   // quality

// layout constants
var _pad      = 22;
var _header_h = 52;
var _line_h   = 32;
draw_set_font(fnt_body);
var _row_h    = string_height("Ay") + 14;
var _div_gap  = 14;
var _prompt_h = _header_h;

// === adjust to taste ===
var _nudge_x     = 0;
var _nudge_y     = 0;
var _fixed_w     = 0;
var _prompt_font = fnt_title;
// =======================

// animated values (lerp driven by anim_t in Step)
var _shown_money  = round(lerp(0, grand_total,  anim_t));
var _shown_scoops = round(lerp(0, total_scoops, anim_t));

// build summary rows: each { text, col }
var _summary = [];
array_push(_summary, { text: "Orders served: " + string(orders_served) + " / " + string(orders_target), col: _ink });
array_push(_summary, { text: "Earned today: $" + string(_shown_money), col: _green });
if (coins_banked > 0) {
    array_push(_summary, { text: "(deliveries $" + string(total_money) + " + banked $" + string(coins_banked) + ")", col: _ink });
}
array_push(_summary, { text: "SCOOPS earned: " + string(_shown_scoops), col: _yellow });
array_push(_summary, { text: "Avg quality: " + string(round(avg_score)), col: _blue });

var _prompt = anim_done ? ("Click to start Day " + string(day_num + 1)) : "Click to skip...";

// measure panel width (each string in the font it will draw with)
var _title = "DAY " + string(day_num) + " COMPLETE";
draw_set_font(fnt_title);
var _maxw = string_width(_title);

draw_set_font(fnt_body);
for (var _m = 0; _m < array_length(_summary); _m++) _maxw = max(_maxw, string_width(_summary[_m].text));
for (var _m = 0; _m < orders_served; _m++) {
    var _r  = global.day_log[_m];
    var _rt = "#" + string(_r.order_num) + "  " + _r.customer_name + "   " + _r.rank + "   $" + string(_r.money);
    _maxw   = max(_maxw, string_width(_rt));
}
draw_set_font(_prompt_font);
_maxw = max(_maxw, string_width(_prompt));

// panel dimensions
var _has_list = (orders_served > 0);
var _pw = (_fixed_w > 0) ? _fixed_w : (_maxw + _pad * 2);
var _body_h = _pad * 0.5
            + array_length(_summary) * _line_h
            + (_has_list ? (_div_gap * 2 + orders_served * _row_h) : 0)
            + _div_gap
            + _prompt_h;
var _ph = _header_h + _body_h;

// centered origin (+ nudge + shake)
var _px = round((_gw - _pw) * 0.5) + _nudge_x + shake_ox;
var _py = round((_gh - _ph) * 0.5) + _nudge_y + shake_oy;

// paper fill
draw_set_color(make_color_rgb(250, 248, 240));
draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);

// red header band + title
draw_set_color(make_color_rgb(200, 45, 45));
draw_rectangle(_px, _py, _px + _pw, _py + _header_h, false);
draw_set_font(fnt_title);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(_px + _pw * 0.5, _py + _header_h * 0.5, _title);

// body
var _midx = _px + _pw * 0.5;
var _iy   = _py + _header_h + _pad * 0.5;
draw_set_font(fnt_body);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

// summary rows (colored per entry)
for (var _s = 0; _s < array_length(_summary); _s++) {
    draw_set_color(_summary[_s].col);
    draw_text(_midx, _iy, _summary[_s].text);
    _iy += _line_h;
}

// itemized list
if (_has_list) {
    _iy += _div_gap;
    draw_set_color(make_color_rgb(224, 170, 170));
    draw_line(_px + 12, _iy, _px + _pw - 12, _iy);
    _iy += _div_gap;

    for (var _o = 0; _o < orders_served; _o++) {
        var _r = global.day_log[_o];

        // split into three segments so grade + money color independently
        var _seg_a = "#" + string(_r.order_num) + "  " + _r.customer_name + "   ";
        var _seg_b = _r.rank;
        var _seg_c = "   $" + string(_r.money);

        var _wa = string_width(_seg_a);
        var _wb = string_width(_seg_b);
        var _wc = string_width(_seg_c);
        var _cx = _midx - (_wa + _wb + _wc) * 0.5;   // left start for a centered multi-color line
        var _ty = _iy + _row_h * 0.5;

        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);

        draw_set_color(_ink);
        draw_text(_cx, _ty, _seg_a);            _cx += _wa;

        draw_set_color(scr_grade_color(_r.rank));
        draw_text(_cx, _ty, _seg_b);            _cx += _wb;

        draw_set_color(_green);
        draw_text(_cx, _ty, _seg_c);

        // divider
        draw_set_color(make_color_rgb(224, 170, 170));
        draw_line(_px + 12, _iy + _row_h, _px + _pw - 12, _iy + _row_h);

        _iy += _row_h;
    }
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
}

// footer band + prompt
var _footer_y = _py + _ph - _prompt_h;
if (anim_done) {
    draw_set_color(make_color_rgb(200, 45, 45));
    draw_rectangle(_px, _footer_y, _px + _pw, _py + _ph, false);
    draw_set_font(_prompt_font);
    draw_set_color(c_white);
} else {
    draw_set_font(fnt_body);
    draw_set_color(make_color_rgb(150, 150, 150));
}
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(_px + _pw * 0.5, _footer_y + _prompt_h * 0.5, _prompt);

// red border
draw_set_color(make_color_rgb(180, 60, 60));
draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);

// restore
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_font(-1);