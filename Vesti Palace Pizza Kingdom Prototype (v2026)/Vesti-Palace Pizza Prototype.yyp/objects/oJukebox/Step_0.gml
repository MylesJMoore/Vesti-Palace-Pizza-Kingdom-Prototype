// Smooth volume fades
if current_sound_id != noone && audio_is_playing(current_sound_id) {
    track_volume = lerp(track_volume, fade_target, fade_speed);
    audio_sound_gain(current_sound_id, track_volume, 0);
}