//Turn off System Cursor
window_set_cursor(cr_none);

//Set Default Game Mode as we start in the Main Menu
global.game_mode = "UI";

//Default Handmode
global.hand_mode = HAND_MODE.GRAB;

//Player
global.player_can_move = true;

// Set Default Return Room
if (!variable_global_exists("return_room")) {
    global.return_room = VestiOffice;
}

//Set Last room
last_room = room;

//Go to next room
room_goto_next();

//Counter Money Rectangle Area
global.counter_min_x = 0;
global.counter_min_y = 400;
global.counter_max_x = 1362;
global.counter_max_y = 680;

//Ingredient Initialization
global.active_ingredient = INGREDIENT.NONE;

//Topping Depth
global.topping_depth = 0;

//Customers
global.customer_queue = ["counter_customer", "counter_customer_2"];
global.current_customer = 0;