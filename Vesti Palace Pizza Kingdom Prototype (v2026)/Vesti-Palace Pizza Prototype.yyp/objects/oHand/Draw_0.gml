var spr = spr_default;

switch (cursor_state) {
    case 1: spr = spr_hover; break;
    case 2: spr = spr_click; break;
}

draw_sprite(spr, 0, x, y);