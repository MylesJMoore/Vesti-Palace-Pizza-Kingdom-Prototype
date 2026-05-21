// Wiggle (Balatro feel)
if (held) {
    image_angle = sin(current_time / 90 + wiggle_phase) * 2;
} else {
    image_angle = lerp(image_angle, 0, 0.2);
}

// Damping + movement
if (!held) {
    vx *= slide;
    vy *= slide;
} else {
    vx *= drag_friction_x;
    vy *= drag_friction_y;
}

x += vx;
y += vy;

// Sprite half-size for boundary math
var hw = (sprite_width * image_xscale) * 0.5;
var hh = (sprite_height * image_yscale) * 0.5;

switch (drag_bounds_mode) {
    case 0:
        // no clamping
        break;
    case 1:
        // clamp to counter play area
        var cx1 = clamp(x, global.counter_min_x, global.counter_max_x);
        var cy1 = clamp(y, global.counter_min_y, global.counter_max_y);
        if (x != cx1) { x = cx1; vx = 0; }
        if (y != cy1) { y = cy1; vy = 0; }
        break;
    case 2:
        // clamp to full room
	    var cx2 = clamp(x, hw + clamp_buffer_x, room_width - hw - clamp_buffer_x);
	    var cy2 = clamp(y, hh + clamp_buffer_y, room_height - hh - clamp_buffer_y);
	    if (x != cx2) { x = cx2; vx = 0; }
	    if (y != cy2) { y = cy2; vy = 0; }
	    break;
	}