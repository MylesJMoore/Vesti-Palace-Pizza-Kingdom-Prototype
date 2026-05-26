if (global.player_can_move) {
	#region Player Movement

	// Movement Keys
	var right_key = keyboard_check(vk_right) || keyboard_check(ord("D"));
	var left_key = keyboard_check(vk_left) || keyboard_check(ord("A"));
	var up_key = keyboard_check(vk_up) || keyboard_check(ord("W"));
	var down_key = keyboard_check(vk_down) || keyboard_check(ord("S"));

	// Controller Support for Player Movement
	var axis_x = gamepad_axis_value(0, gp_axislh);
	var axis_y = gamepad_axis_value(0, gp_axislv);

	if (abs(axis_x) > 0.2 || abs(axis_y) > 0.2)
	{
	    var magnitude = point_distance(0, 0, axis_x, axis_y);
	    var normalized_x = axis_x / magnitude;
	    var normalized_y = axis_y / magnitude;
    
	    // Adjust the deadzone and ensure the input is still valid
	    if (magnitude > 0.2)
	    {
	        left_key = round(max(-normalized_x, 0));
	        right_key = round(max(normalized_x, 0));
	        up_key = round(max(-normalized_y, 0));
	        down_key = round(max(normalized_y, 0));
	    }
	}


	// Player Running
	if(keyboard_check(vk_shift) || (gamepad_button_check(0, gp_face2))) {
	    move_speed = RUNSPEED;
	} else {
	    move_speed = WALKSPEED;
	}

	// Movement Calculations
	xspeed = (right_key - left_key) * move_speed;
	yspeed = (down_key - up_key) * move_speed;

	#endregion

	#region Pause Player
	//TODO: IMPLEMENT PLAYER PAUSE

	#endregion
	
	#region Open Menu - Keyboard
	//TODO: IMPLEMENT MENU
	#endregion

	#region Player Collision
	//Collision from right to left
	if(place_meeting(x + xspeed, y, obj_wall))
	{
		xspeed = 0;
	}

	//Collision from down to up
	if(place_meeting(x, y + yspeed, obj_wall))
	{
		yspeed = 0;
	}
	#endregion

	#region Player Animation
	//Calculate Player Direction based on speed
	mask_index = sprite[DOWN];

	if(yspeed == 0) {
		if(xspeed > 0) {
			face = RIGHT;
		} 

		if(xspeed < 0) {
			face = LEFT;
		} 
	}

	//Direction horizontal swapping when going diagonal in opposite direction
	if(xspeed > 0 && face == LEFT) {
		face = RIGHT;
	} else if(xspeed > 0 && face != LEFT) {
		face = RIGHT;
	}

	if(xspeed < 0 && face == RIGHT) {
		face = LEFT;
	} else if(xspeed < 0 && face != RIGHT) {

	}

	if(xspeed == 0) {
		if(yspeed > 0) {
			face = DOWN;
		} 

		if(yspeed < 0) {
			face = UP;
		}
	}

	//Direction vertical swapping when going diagonal in opposite direction
	if(yspeed > 0 && face == UP) {
		face = DOWN;
	} else if(yspeed > 0 && face != UP) {
		//8 Directional Vertical Swap Check
		face = DOWN
	}

	if(yspeed < 0 && face == DOWN) {
		face = UP;
	} else if(yspeed < 0 && face != DOWN) {
		//8 Directional Vertical Swap Check
		face = UP;
	}

	if(xspeed == 0 and yspeed == 0) {
		switch (face)
		{
			case UP:
			    face = IDLEUP;
			break;

			case DOWN:
			    face = IDLEDOWN;
			break;
    
			case LEFT:
			    face = IDLELEFT;
			break;
		
			case RIGHT:
			    face = IDLERIGHT;
			break;
		}
	}

	sprite_index = sprite[face];
	current_direction = sprite_information[face];
	
	//Store Player Face Position
	switch (face)
	{
		case UP:
			global.player_face_direction = "Up";
		break;

		case DOWN:
			global.player_face_direction = "Down";
		break;
    
		case LEFT:
			global.player_face_direction = "Left";
		break;
		
		case RIGHT:
			global.player_face_direction = "Right";
		break;
	}

	#endregion

	#region Player Physics

	//Move Player
	x += xspeed;
	y += yspeed;
	
	//Set Player Depth
	depth = -bbox_bottom;

	#endregion

	#region Player Duplicate Object Cleanup
	
	if (instance_number(obj_player) > 1) {
		instance_destroy();
	}
	
	#endregion
}
