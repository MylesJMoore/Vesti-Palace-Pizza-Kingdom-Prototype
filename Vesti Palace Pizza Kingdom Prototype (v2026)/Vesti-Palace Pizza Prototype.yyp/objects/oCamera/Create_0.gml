cam = view_camera[0];

base_w = camera_get_view_width(cam);
base_h = camera_get_view_height(cam);

// Fallbacks if the room view wasn't explicitly sized
if (base_w <= 0) base_w = room_width;
if (base_h <= 0) base_h = room_height;

// Make sure the camera actually starts at base size
camera_set_view_size(cam, base_w, base_h);

zoom      = 1;
zmin      = 1;
zmax      = 4;
zoom_step = 0.25;
camx      = camera_get_view_x(cam);
camy      = camera_get_view_y(cam);
panning   = false;
pan_lx    = 0;
pan_ly    = 0;