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

if show_continue && !confetti_active {
    if rank == "S+" || rank == "S" || rank == "A" || rank == "F+" || rank == "F" || rank == "F-" {
        confetti_active = true;
        confetti = [];
        for (var _i = 0; _i < 60; _i++) {
            var _angle = random(360);
            var _speed = random_range(3, 9);
            var _p = {
                x: 960,
                y: 540,
                vx: lengthdir_x(_speed, _angle),
                vy: lengthdir_y(_speed, _angle) - 4,
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
        
        // Extra gold burst for S+
        if rank == "S+" {
            for (var _i = 0; _i < 40; _i++) {
                var _angle = random(360);
                var _speed = random_range(5, 12);
                var _p = {
                    x: 960,
                    y: 540,
                    vx: lengthdir_x(_speed, _angle),
                    vy: lengthdir_y(_speed, _angle) - 6,
                    col: make_color_rgb(255, 220, 50),
                    size: random_range(8, 16),
                    rot: random(360),
                    rot_speed: random_range(-8, 8)
                };
                array_push(confetti, _p);
            }
        }
    }
}

// Update confetti with gravity
if confetti_active {
    for (var _i = 0; _i < array_length(confetti); _i++) {
        confetti[_i].vy += 0.15;
        confetti[_i].x  += confetti[_i].vx;
        confetti[_i].y  += confetti[_i].vy;
        confetti[_i].rot += confetti[_i].rot_speed;
    }
}