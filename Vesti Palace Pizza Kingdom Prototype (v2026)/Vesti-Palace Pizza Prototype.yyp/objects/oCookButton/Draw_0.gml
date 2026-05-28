draw_self();
draw_set_color(c_black);
draw_set_halign(fa_center);
switch (cook_stage) {
    case 0: draw_text(x, y + 60, "COOK"); break;
    case 1: draw_text(x, y + 60, "OVERCOOK"); break;
    case 2: draw_text(x, y + 60, "BURNT"); break;
}
draw_set_halign(fa_left);