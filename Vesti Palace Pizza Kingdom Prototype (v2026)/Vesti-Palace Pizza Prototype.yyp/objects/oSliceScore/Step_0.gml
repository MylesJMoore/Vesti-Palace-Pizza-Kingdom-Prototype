if !active exit;

// Slam rank letter in
if rank_scale < rank_scale_target {
    rank_scale += slam_speed;
    if rank_scale > rank_scale_target + 0.1 {
        rank_scale = rank_scale_target + 0.1; // slight overshoot
    }
    // Settle back
    rank_scale = lerp(rank_scale, rank_scale_target, 0.2);
}

// Roll display number toward actual score
if display_score < slice_score {
    display_score = min(display_score + roll_speed, slice_score);
}

display_timer--;
if display_timer <= 0 {
    fade_alpha -= 0.02;
    if fade_alpha <= 0 {
        active = false;
        fade_alpha = 1;
        rank_scale = 0;
    }
}