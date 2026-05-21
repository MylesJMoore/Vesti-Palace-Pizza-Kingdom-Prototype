depth = -100000;
//Cursor State
//0 - default
//1 - hover
//2 - click
cursor_state = 0;

//Cursor Sprites
spr_default = spr_cursor_default;
spr_hover   = spr_cursor_hover;
spr_click   = spr_cursor_click;

hover_target = noone;
held_item    = noone;
is_clicking = false;

// Optional: if you later want smooth cursor movement
x = mouse_x;
y = mouse_y;