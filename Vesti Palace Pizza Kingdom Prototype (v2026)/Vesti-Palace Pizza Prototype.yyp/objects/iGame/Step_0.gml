// Detect room change
if (room != last_room) {

    // If we just LEFT an RPG room and entered a UI room, store return room
    if (last_room == VestiOffice || last_room == VestiPalace) {
        // Only store when entering a UI room
        if (!(room == VestiOffice || room == VestiPalace)) {
            global.return_room = last_room;
        }
    }

    last_room = room;
}

// Determine mode for current room
if(room == VestiOffice || room == VestiPalace) {
	global.game_mode = "RPG";
} else {
	global.game_mode = "UI";
}

// Hide and freeze player if we are in a UI room
if (global.game_mode == "UI") {
    if (instance_exists(obj_player)) {
		obj_player.visible = false;
	}
    global.player_can_move = false;
} else {
    if (instance_exists(obj_player)) {
		obj_player.visible = true;
	}
    global.player_can_move = true;
}