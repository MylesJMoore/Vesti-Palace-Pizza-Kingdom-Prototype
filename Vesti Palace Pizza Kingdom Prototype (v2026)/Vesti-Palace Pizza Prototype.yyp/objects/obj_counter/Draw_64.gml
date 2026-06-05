var _scorer = instance_find(oSliceScore, 0);
if !instance_exists(_scorer) exit;
if !_scorer.active exit;

var _cx = display_get_gui_width() * 0.5;
var _cy = display_get_gui_height() * 0.5;

draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Dark overlay
draw_set_color(c_black);
draw_set_alpha(0.6);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// Confetti
if _scorer.confetti_active {
    var _conf = _scorer.confetti;
    for (var _i = 0; _i < array_length(_conf); _i++) {
        var _p = _conf[_i];
        draw_set_color(_p.col);
        draw_set_alpha(0.9);
        draw_rectangle(
            _p.x - _p.size,
            _p.y - _p.size,
            _p.x + _p.size,
            _p.y + _p.size,
            false
        );
    }
}

// SLICE label
draw_set_color(c_yellow);
draw_set_alpha(1);
draw_text_transformed(_cx, _cy - 140, "S.L.I.C.E", 1, 1, 0);

// Rolling score number
draw_set_color(c_white);
draw_set_alpha(1);
if !_scorer.show_continue {
    var _fake = ((_scorer.show_timer * 3) mod 201);
    draw_text_transformed(_cx, _cy - 60, string(_fake), 1.5, 1.5, 0);
} else {
    draw_text_transformed(_cx, _cy - 60, string(floor(_scorer.display_score)), 1.5, 1.5, 0);
}

// Rank — only show after show_continue
if _scorer.show_continue {
    var _rank_color = c_white;
    switch (_scorer.rank) {
        case "S+": _rank_color = make_color_rgb(255, 220, 50);  break;
        case "S":  _rank_color = make_color_rgb(255, 220, 50);  break;
        case "A":  _rank_color = make_color_rgb(100, 255, 100); break;
        case "B":  _rank_color = make_color_rgb(100, 200, 255); break;
        case "C":  _rank_color = make_color_rgb(200, 200, 200); break;
        case "D+": _rank_color = make_color_rgb(255, 140, 0);   break;
        case "D":  _rank_color = make_color_rgb(255, 140, 0);   break;
        case "D-": _rank_color = make_color_rgb(255, 140, 0);   break;
        case "F+": _rank_color = make_color_rgb(255, 60, 60);   break;
        case "F":  _rank_color = make_color_rgb(255, 60, 60);   break;
        case "F-": _rank_color = make_color_rgb(255, 60, 60);   break;
    }
    draw_set_color(_rank_color);
    draw_set_alpha(1);

    switch (_scorer.rank) {
        case "F-":
        case "F":
        case "F+":
            var _sx = _cx + random_range(-10, 10);
            var _sy = (_cy + 60) + random_range(-10, 10);
            draw_text_transformed(_sx, _sy, _scorer.rank, _scorer.rank_scale * 4, _scorer.rank_scale * 4, random_range(-5, 5));
            break;

        case "D-":
        case "D":
        case "D+":
            var _wa = sin(_scorer.rank_wobble) * 10;
            draw_text_transformed(_cx, _cy + 60, _scorer.rank, _scorer.rank_scale * 4, _scorer.rank_scale * 4, _wa);
            break;

        case "S+":
            var _pulse = 1 + sin(_scorer.rank_wobble * 2) * 0.12;
            var _spin  = sin(_scorer.rank_wobble) * 3;
            draw_text_transformed(_cx, _cy + 60, _scorer.rank, _scorer.rank_scale * 4 * _pulse, _scorer.rank_scale * 4 * _pulse, _spin);
            break;

        default:
            draw_text_transformed(_cx, _cy + 60, _scorer.rank, _scorer.rank_scale * 4, _scorer.rank_scale * 4, 0);
            break;
    }
}

// Phase messages
if _scorer.show_timer < 60 {
    // silence — let score roll
}
else if _scorer.show_timer < 150 {
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_text_transformed(_cx, _cy + 140, "Calculating square zero of pepperoni...", 1, 1, 0);
}
else if _scorer.show_timer < 240 {
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_text_transformed(_cx, _cy + 140, "Accounting for burnt cheese coefficient...", 1, 1, 0);
}
else if _scorer.show_timer < 300 {
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_text_transformed(_cx, _cy + 140, "Consulting the ancient pizza scrolls...", 1, 1, 0);
}
else {
    draw_set_color(c_white);
    draw_set_alpha(1);

    switch (_scorer.rank) {
        case "F-":
            draw_text_transformed(_cx, _cy + 140, "This is a historic failure. I am impressed.", 1, 1, 0);
            draw_text_transformed(_cx, _cy + 180, "If this was a game, you would get a score of ZERO.", 1, 1, 0);
            break;
        case "F":
            draw_text_transformed(_cx, _cy + 140, "...We have no words.", 1, 1, 0);
            draw_text_transformed(_cx, _cy + 180, "The customer is crying.", 1, 1, 0);
            break;
        case "F+":
            draw_text_transformed(_cx, _cy + 140, "Technically almost the worst. But like, barely.", 1, 1, 0);
            draw_text_transformed(_cx, _cy + 180, "Still bad. Very bad.", 1, 1, 0);
            break;
        case "D-":
            draw_text_transformed(_cx, _cy + 140, "A noble attempt. Just kidding. Truly tragic.", 1, 1, 0);
            draw_text_transformed(_cx, _cy + 180, "We don't care. Actually we do.", 1, 1, 0);
            break;
        case "D":
            draw_text_transformed(_cx, _cy + 140, "That was... something.", 1, 1, 0);
            draw_text_transformed(_cx, _cy + 180, "The customer is disappointed.", 1, 1, 0);
            break;
        case "D+":
            draw_text_transformed(_cx, _cy + 140, "Almost not a shitty pizza.", 1, 1, 0);
            draw_text_transformed(_cx, _cy + 180, "High praise from the customer though.", 1, 1, 0);
            break;
        default:
            draw_text_transformed(_cx, _cy + 140, "Here's your score.", 1, 1, 0);
            draw_text_transformed(_cx, _cy + 180, "Love it or like it. We don't care.", 1, 1, 0);
            break;
    }

    var _blink = (current_time mod 800) < 400;
    if _blink {
        draw_set_color(c_yellow);
        draw_set_alpha(1);
        draw_text_transformed(_cx, _cy + 230, "Click to continue", 1, 1, 0);
    }
}

draw_set_alpha(1);
draw_set_halign(fa_left);