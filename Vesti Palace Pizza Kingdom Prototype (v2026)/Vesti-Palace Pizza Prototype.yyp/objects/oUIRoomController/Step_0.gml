if (room != MainMenu && room != DayEndTally) {
    if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("C"))) {
        room_goto(global.return_room);
    }
}