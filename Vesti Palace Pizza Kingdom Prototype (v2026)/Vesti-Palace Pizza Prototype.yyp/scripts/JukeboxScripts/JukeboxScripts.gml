function jukebox_play(track) {
    var _jb = instance_find(oJukebox, 0);
    if !instance_exists(_jb) exit;
    
    // Already playing this track — do nothing
    if _jb.current_track == track && audio_is_playing(_jb.current_sound_id) {
        exit;
    }
    
    // Stop old track
    if _jb.current_sound_id != noone && audio_is_playing(_jb.current_sound_id) {
        audio_stop_sound(_jb.current_sound_id);
    }
    
    // Start new track looping
    _jb.current_track = track;
    _jb.current_sound_id = audio_play_sound(track, 1, true);
    _jb.track_volume = 1;
    _jb.fade_target = 1;
    audio_sound_gain(_jb.current_sound_id, 1, 0);
}

function jukebox_stop() {
    var _jb = instance_find(oJukebox, 0);
    if !instance_exists(_jb) exit;
    if _jb.current_sound_id != noone {
        audio_stop_sound(_jb.current_sound_id);
        _jb.current_track = noone;
        _jb.current_sound_id = noone;
    }
}

function sfx_play(snd, pitch_vary = true, vol = 1) {
    var _snd = audio_play_sound(snd, 5, false);
    if pitch_vary {
        audio_sound_pitch(_snd, random_range(0.92, 1.08));
    }
    audio_sound_gain(_snd, vol, 0);
    return _snd;
}

function jukebox_duck(target_vol, speed) {
    var _jb = instance_find(oJukebox, 0);
    if !instance_exists(_jb) exit;
    _jb.fade_target = target_vol;
    _jb.fade_speed = speed;
}