depth = -100000;

// Cursor State
cursor_state = 0;

// Cursor Sprites
//spr_default = spr_hand_open;
//spr_hover   = spr_hand_open;
//spr_click   = spr_hand_closed;

spr_default = spr_cursor_default;
spr_hover   = spr_cursor_hover;
spr_click   = spr_cursor_click;

hover_target = noone;
held_item    = noone;

//Starting Position
x = 800;
y = 475;

// room-entry safety
input_lock_frames = 0;
await_mouse_release = false;

//Shake
shake_intensity = 0;
shake_duration  = 0;
shake_timer     = 0;