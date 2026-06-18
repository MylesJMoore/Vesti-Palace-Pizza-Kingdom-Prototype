if !active exit;

// Slam rank letter in
if rank_scale < rank_scale_target {
    rank_scale += slam_speed;
    if rank_scale > rank_scale_target + 0.1 {
        rank_scale = rank_scale_target + 0.1;
    }
    rank_scale = lerp(rank_scale, rank_scale_target, 0.2);
}

// Roll slowly toward real score
if display_score < slice_score {
    display_score = min(display_score + (slice_score / 240), slice_score);
}

// Wobble for bad ranks
if rank == "F-" || rank == "F" || rank == "F+" 
|| rank == "D-" || rank == "D" || rank == "D+" {
    rank_wobble += 0.15;
}

// Pulse for A
if rank == "A" {
    rank_wobble += 0.08;
}

// Pulse for S
if rank == "S" {
    rank_wobble += 0.12;
}

// Pulse for S+
if rank == "S+" {
    rank_wobble += 0.16;
}

// Show timer
show_timer++;
if show_timer >= 300 && !show_continue {
    show_continue = true;
    rank_scale = 0;
    rank_flash = 1;
    screen_shake(12, 20);
}

// Fade flash
if rank_flash > 0 {
    rank_flash -= 0.05;
    if rank_flash < 0 rank_flash = 0;
}

// Spawn confetti once for A and above
if show_continue && !confetti_active {
    if rank == "S+" || rank == "S" || rank == "A" || rank == "F-" {
        confetti_active = true;
        confetti = [];
        for (var _i = 0; _i < 60; _i++) {
            var _p = {
                x: random(1920),
                y: random_range(-100, 0),
                vx: random_range(-2, 2),
                vy: random_range(3, 8),
                col: choose(
                    make_color_rgb(255, 220, 50),
                    make_color_rgb(100, 255, 100),
                    make_color_rgb(100, 200, 255),
                    c_white,
                    make_color_rgb(255, 100, 200)
                ),
                size: random_range(6, 14),
                rot: random(360),
                rot_speed: random_range(-5, 5)
            };
            array_push(confetti, _p);
        }
    }
}

// Update confetti
if confetti_active {
    for (var _i = 0; _i < array_length(confetti); _i++) {
        confetti[_i].x  += confetti[_i].vx;
        confetti[_i].y  += confetti[_i].vy;
        confetti[_i].rot += confetti[_i].rot_speed;
    }
}