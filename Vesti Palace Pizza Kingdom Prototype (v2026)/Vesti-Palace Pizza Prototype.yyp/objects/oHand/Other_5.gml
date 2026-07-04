if paint_loop_snd != noone && audio_is_playing(paint_loop_snd) {
    audio_stop_sound(paint_loop_snd);
    paint_loop_snd = noone;
}