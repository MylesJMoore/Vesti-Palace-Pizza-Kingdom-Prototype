function screen_shake(intensity, duration) {
    if !instance_exists(oHand) exit;
    oHand.shake_intensity = intensity;
    oHand.shake_duration  = duration;
    oHand.shake_timer     = duration;
}