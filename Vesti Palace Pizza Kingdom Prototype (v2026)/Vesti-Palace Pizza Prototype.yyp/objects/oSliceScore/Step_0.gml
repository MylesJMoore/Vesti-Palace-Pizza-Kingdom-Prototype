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
if rank == "S+" {
    rank_wobble += 0.08;
}

// Show timer + reveal trigger
show_timer++;
if show_timer >= 300 && !show_continue {
    show_continue = true;
    rank_scale = 0;
    rank_flash = 1;
    screen_shake(12, 20);
    if rank == "S+" || rank == "S" || rank == "A" {
        jukebox_play(snd_music_victory);
    } else if rank == "B" || rank == "C" {
        jukebox_play(snd_sfx_cheer_small);
    } else {
        jukebox_play(snd_sfx_groan);
    }
}

// Once the big number has finished rolling, slide the satisfaction line in
if (show_continue) {                       // was: display_score >= slice_score - 0.5
    sat_reveal = min(sat_reveal + 0.06, 1);
}

// Fade rank flash
if rank_flash > 0 {
    rank_flash -= 0.05;
    if rank_flash < 0 rank_flash = 0;
}

// Fade tier-up flash
if tier_up_flash > 0 {
    tier_up_flash -= 0.03;
    if tier_up_flash < 0 tier_up_flash = 0;
}

// Count down tier banner
if tier_banner_timer > 0 {
    tier_banner_timer--;
}

// Spring earnings pop back down
if earnings_pop > 1 {
    earnings_pop = lerp(earnings_pop, 1, 0.15);
}

// Apply rewards once, shortly after reveal
if show_continue && !rewards_applied {
    scoops_fly_timer++;
    if scoops_fly_timer >= 40 {
        rewards_applied = true;
        earnings_pop = 1.6;
        earnings_shown = true;

        // Money
        global.money += money_earned;
		
        // Scoops (capped at 800)
        var _before = global.scoops;
        global.scoops = min(global.scoops + scoops_earned, 800);
		
        // Tier tick-over check
        var _tier_before = floor(_before / 100);
        var _tier_after  = floor(global.scoops / 100);
        if _tier_after > _tier_before {
            tier_up_flash = 1;
            tier_banner_timer = 180;
            screen_shake(15, 25);

            // Pull tier title/rank from HUD
            var _hud = instance_find(oHUD, 0);
            if instance_exists(_hud) {
                tier_banner_title = _hud.scoops_titles[_tier_after];
                tier_banner_rank  = _hud.scoops_ranks[_tier_after];
            }

            // Tier-up sound
            jukebox_play(snd_sfx_tier_up);

            // Big confetti burst
            for (var _i = 0; _i < 80; _i++) {
                var _angle = random(360);
                var _speed = random_range(4, 12);
                var _p = {
                    x: 960, y: 300,
                    vx: lengthdir_x(_speed, _angle),
                    vy: lengthdir_y(_speed, _angle) - 6,
                    col: choose(
                        make_color_rgb(255, 220, 50),
                        make_color_rgb(100, 255, 100),
                        make_color_rgb(100, 200, 255),
                        c_white
                    ),
                    size: random_range(6, 14),
                    rot: random(360),
                    rot_speed: random_range(-8, 8)
                };
                array_push(confetti, _p);
            }
            confetti_active = true;
        }

        // Earnings burst from random screen spots
        for (var _i = 0; _i < 30; _i++) {
            var _p = {
                x: random(1920),
                y: random_range(400, 800),
                vx: random_range(-3, 3),
                vy: random_range(-8, -3),
                col: choose(
                    make_color_rgb(100, 255, 100),
                    make_color_rgb(255, 220, 50)
                ),
                size: random_range(5, 12),
                rot: random(360),
                rot_speed: random_range(-6, 6)
            };
            array_push(confetti, _p);
        }
        confetti_active = true;

        // Store last grade for HUD
        global.last_slice_score = slice_score;
        global.last_rank = rank;
        global.pizzas_made++;
		
		scr_day_record_delivery({
		    customer      : global.current_customer,
		    customer_name : scr_customer_name(global.current_customer),
		    slice_score   : global.last_slice_score,
		    satisfaction  : -1,   // wire to your _satisfaction later if you want it on the tally
		    rank          : global.last_rank,
		    money         : global.money,
		    scoops        : global.scoops
		});
    }
}

// Update confetti
if confetti_active {
    for (var _i = 0; _i < array_length(confetti); _i++) {
        confetti[_i].vy += 0.15;
        confetti[_i].x  += confetti[_i].vx;
        confetti[_i].y  += confetti[_i].vy;
        confetti[_i].rot += confetti[_i].rot_speed;
    }
}