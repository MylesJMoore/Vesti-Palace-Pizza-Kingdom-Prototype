event_inherited();

hint_pulse += 0.08;

if box_state == "closed" && !held && room == CounterPizzaDelivery {
    depth = -200;
}

if box_state == "open" && !held {
    var pizza = instance_find(oPizzaV2, 0);
    
    // Default — no pizza, no glow
    glow_intensity = 0;
    
    if instance_exists(pizza) {
        var dx = pizza.x - x;
        var dy = pizza.y - y;
        var _dist = sqrt(dx*dx + dy*dy);
        
        // Glow scales from far (low) to close (high)
        var _max_range = snap_radius * glow_distance_radius;
        var _t = clamp(1 - (_dist / _max_range), 0, 1);
        glow_intensity = _t;
        
        // Sparkle rate scales with intensity — more sparkles closer
        sparkle_timer++;
        var _sparkle_rate = lerp(20, 3, glow_intensity); // slower far, faster near
        if sparkle_timer >= _sparkle_rate && glow_intensity > 0.05 {
            sparkle_timer = 0;
            var _angle = random(360);
            var _spawn_dist = random_range(snap_radius * 0.3, snap_radius * image_xscale * (0.6 + glow_intensity * 0.6));
            var _sx = x + lengthdir_x(_spawn_dist, _angle);
            var _sy = y + lengthdir_y(_spawn_dist, _angle);
            var _s = instance_create_layer(_sx, _sy, "Instances", oGlobSplat);
            _s.col = make_color_rgb(255, 240, 150);
            _s.depth = -99996;
            _s.vx = random_range(-1, 1);
            _s.vy = random_range(-2, -0.5);
            _s.size = lerp(2, 6, glow_intensity);
            _s.life = 20;
            _s.max_life = 20;
            _s.gravity = -0.02;
        }

        if !pizza.held {
            if dx*dx + dy*dy < snap_radius * snap_radius {
                pizza.x = x;
                pizza.y = y;
                pizza.vx = 0;
                pizza.vy = 0;
                pizza_ref = pizza;
                pizza.can_be_picked_up = false;
                pizza.can_be_clicked = false;

                box_state = "closed";
                sprite_index = spr_pizza_box_closed;
                depth = -99997;
                can_be_picked_up = true;
                can_be_clicked = false;
                screen_shake(6, 12);

                repeat(20) {
                    var _angle2 = random(360);
                    var _speed2 = random_range(2, 6);
                    var _burst = instance_create_layer(x, y, "Instances", oGlobSplat);
                    _burst.col = make_color_rgb(255, 240, 150);
                    _burst.depth = -99996;
                    _burst.vx = lengthdir_x(_speed2, _angle2);
                    _burst.vy = lengthdir_y(_speed2, _angle2) - 2;
                    _burst.size = random_range(4, 9);
                    _burst.life = 26;
                    _burst.max_life = 26;
                    _burst.gravity = 0.1;
                }

                global.pizza_sauce    = pizza.sauce_globs;
                global.pizza_cheese   = pizza.cheese_globs;
                global.pizza_cook     = pizza.cook_state;
                global.pizza_toppings = instance_number(oTopping);
                global.pizza_ready    = true;
            }
        }
    }
}