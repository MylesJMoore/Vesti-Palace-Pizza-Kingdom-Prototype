if instance_number(oJukebox) > 1 {
    instance_destroy();
    exit;
}
instance_persistent = true;

current_track = noone;
current_sound_id = noone;
track_volume = 1;

fade_target = 1;
fade_speed = 0.02;