// Smoothly animate the bar toward actual scoops
display_scoops = lerp(display_scoops, global.scoops, 0.1);

// Toggle on H
if keyboard_check_pressed(ord("H")) {
    hud_shown = !hud_shown;
    hud_offset_target = hud_shown ? 0 : hud_hidden_offset;
}

// Smooth slide
hud_offset = lerp(hud_offset, hud_offset_target, 0.2);

// existing scoops lerp
display_scoops = lerp(display_scoops, global.scoops, 0.1);