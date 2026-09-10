/// oDayTally — Step
if (!anim_done) {
    anim_t += (delta_time / 1000000) / anim_dur;   // delta_time is MICROSECONDS
    if (anim_t >= 1) { anim_t = 1; anim_done = true; }
}

if (shake_t > 0) {
    shake_t -= delta_time / 1000000;
    var _f = max(0, shake_t) / shake_dur;
    shake_ox = irandom_range(-1, 1) * shake_mag * _f;
    shake_oy = irandom_range(-1, 1) * shake_mag * _f;
} else {
    shake_ox = 0;
    shake_oy = 0;
}

var _pressed = mouse_check_button_pressed(mb_left)
            || keyboard_check_pressed(vk_enter)
            || keyboard_check_pressed(vk_space);

if (_pressed) {
    if (!anim_done) {
        anim_t = 1;          // first press: finish the count-up
        anim_done = true;
    } else {
        scr_day_next();          // day_number++, reset counters, roll next customer
        room_goto(VestiPalace);  // new day opens in the overworld
    }
}