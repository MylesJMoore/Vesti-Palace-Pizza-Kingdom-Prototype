var winw = window_get_width();
var winh = window_get_height();
if (winw <= 0 || winh <= 0) exit;   // window not ready

var wmx = window_mouse_get_x();       // screen-space, camera-independent
var wmy = window_mouse_get_y();

// --- ZOOM toward cursor ---
var wheel = mouse_wheel_up() - mouse_wheel_down();
if (wheel != 0) {
    var vw_old = camera_get_view_width(cam);
    var vh_old = camera_get_view_height(cam);
    // world point currently under the cursor
    var world_x = camx + (wmx / winw) * vw_old;
    var world_y = camy + (wmy / winh) * vh_old;

    zoom = clamp(zoom + wheel * zoom_step, zmin, zmax);

    // floor the view size to whole pixels → no sub-pixel cursor wobble
    var vw = floor(base_w / zoom);
    var vh = floor(base_h / zoom);

    // reposition so that same world point stays under the cursor
    camx = world_x - (wmx / winw) * vw;
    camy = world_y - (wmy / winh) * vh;

    camera_set_view_size(cam, vw, vh);
}

// --- PAN (middle-mouse drag) ---
if (mouse_check_button_pressed(mb_middle)) { panning = true; pan_lx = wmx; pan_ly = wmy; }
if (panning && mouse_check_button(mb_middle)) {
    var scale = camera_get_view_width(cam) / winw;   // world px per screen px
    camx -= (wmx - pan_lx) * scale;
    camy -= (wmy - pan_ly) * scale;
    pan_lx = wmx;
    pan_ly = wmy;
}
if (mouse_check_button_released(mb_middle)) panning = false;

// clamp base position inside the room
var vw2 = camera_get_view_width(cam);
var vh2 = camera_get_view_height(cam);
camx = clamp(camx, 0, max(0, room_width  - vw2));
camy = clamp(camy, 0, max(0, room_height - vh2));