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
avg_score    = (orders_served > 0) ? (_sum_score / orders_served) : 0;
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