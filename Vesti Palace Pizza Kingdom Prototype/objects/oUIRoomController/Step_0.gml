if (global.game_mode == "UI" && room != MainMenu) {
    if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("E")) || keyboard_check_pressed(ord("C"))) {
	    room_goto(global.return_room);
	}
}