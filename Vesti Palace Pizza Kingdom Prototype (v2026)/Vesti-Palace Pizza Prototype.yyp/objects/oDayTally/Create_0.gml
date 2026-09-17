/// oDayTally — Create
depth = -1000;

day_num       = global.day_number;
orders_target = scr_orders_target(day_num);

var _log      = global.day_log;
orders_served = array_length(_log);

total_money  = 0;
total_scoops = 0;
var _sum_score = 0;
for (var i = 0; i < orders_served; i++) {
    var _r = _log[i];
    total_money  += _r.money;
    total_scoops += _r.scoops;
    _sum_score   += _r.slice_score;
}

//Average Score Rank
var _ranks = ["F-","F","F+","D-","D","D+","C","B","A","S","S+"];
avg_score    = (orders_served > 0) ? (_sum_score / orders_served) : 0;
avg_score_rank = 0;
avg_score_letter = "";
if      (avg_score >= 97) avg_score_rank = 10;
else if (avg_score >= 90) avg_score_rank = 9;
else if (avg_score >= 80) avg_score_rank = 8;
else if (avg_score >= 70) avg_score_rank = 7;
else if (avg_score >= 60) avg_score_rank = 6;
else if (avg_score >= 50) avg_score_rank = 5;
else if (avg_score >= 40) avg_score_rank = 4;
else if (avg_score >= 30) avg_score_rank = 3;
else if (avg_score >= 20) avg_score_rank = 2;
else if (avg_score >= 10) avg_score_rank = 1;
else                      avg_score_rank = 0;
avg_score_letter = _ranks[avg_score_rank];

// Average Score Color
avg_score_color = c_white;
switch (avg_score_letter) {
    case "S+": avg_score_color = make_color_rgb(255, 220, 50);  break;
    case "S":  avg_score_color = make_color_rgb(255, 220, 50);  break;
    case "A":  avg_score_color = make_color_rgb(100, 255, 100); break;
    case "B":  avg_score_color = make_color_rgb(100, 200, 255); break;
    case "C":  avg_score_color = make_color_rgb(200, 200, 200); break;
    case "D+": avg_score_color = make_color_rgb(255, 140, 0);   break;
    case "D":  avg_score_color = make_color_rgb(255, 140, 0);   break;
    case "D-": avg_score_color = make_color_rgb(255, 140, 0);   break;
    case "F+": avg_score_color = make_color_rgb(255, 60, 60);   break;
    case "F":  avg_score_color = make_color_rgb(255, 60, 60);   break;
    case "F-": avg_score_color = make_color_rgb(255, 60, 60);   break;
}

//Coins
coins_banked = global.coins_banked_today;
grand_total  = total_money + coins_banked;

// count-up animation (1s, frame-rate independent via delta_time)
anim_dur  = 1.0;
anim_t    = 0;
anim_done = (orders_served == 0);

// local shake (screen_shake() no-ops here — no oHand in this room)
shake_dur = 0.35;
shake_t   = shake_dur;
shake_mag = 8;
shake_ox  = 0;
shake_oy  = 0;

// swap these for your real UI fonts, or text renders at the tiny default
fnt_title = fnt_dialogue;
fnt_body  = fnt_dialogue;