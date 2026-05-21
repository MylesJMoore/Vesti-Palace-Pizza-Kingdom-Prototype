// Drag bounds mode
// 0 = none
// 1 = counter rect (global.counter_*)
// 2 = room rect (full room)
drag_bounds_mode = 2; 

//Determine if object is clickable like a window to do something
clickable_main_menu_start = false;

//Determine if object is draggable or statdionary clickable or both
can_be_picked_up = true;
can_be_clicked = false;

//Physics Variables
depth = -100;
held = false;
hold_offset_x = 0;
hold_offset_y = 0;
clamp_buffer_x = 0; //Adds a buffer for full room bounds
clamp_buffer_y = 0; //Adds a buffer for full room bounds

vx = 0;
vy = 0;

//Unique offset for Balatro Wiggle
wiggle_phase = random(1000);

/*
[Quick Tuning Rules]
If you grab an item and it feels too “quick”:
1. first lower drag_strength by 0.02
2. if still too quick, lower max_speed by 2
3. if it jitters/twitches while held, lower drag_friction by 0.02
*/
// Physics Defaults (tune per item later)
drag_strength = 0.22; // lower = heavier
max_speed    = 26;   // prevents crazy flings
slide   = 0.93; // higher = more glide
drag_friction_x = 0.84;
drag_friction_y = 0.84;