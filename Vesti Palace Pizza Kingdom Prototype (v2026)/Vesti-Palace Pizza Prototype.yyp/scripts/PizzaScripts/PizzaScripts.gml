function PizzaScripts(pizza, world_x, world_y, ingredient) {
    var surf = -1;
    
    if (ingredient == INGREDIENT.SAUCE) {
        surf = pizza.surf_sauce;
    } else if (ingredient == INGREDIENT.SPECIALSAUCE) {
        surf = pizza.surf_sauce;
    } else if (ingredient == INGREDIENT.CHEESE) {
        surf = pizza.surf_cheese;
    }
    
    if (!surface_exists(surf)) exit;
    
    var sx = pizza.image_xscale;
    var sy = pizza.image_yscale;
    
    var surf_x = (world_x - pizza.x) / sx + pizza.surf_size * 0.5;
    var surf_y = (world_y - pizza.y) / sy + pizza.surf_size * 0.5;
    
    var dx = surf_x - pizza.surf_size * 0.5;
    var dy = surf_y - pizza.surf_size * 0.5;
    var brush_half = 60;
    var clip_radius = pizza.pizza_radius_surf - brush_half;
    if (dx*dx + dy*dy > clip_radius * clip_radius) exit;
    
    var rand_angle = random(360);

	surface_set_target(surf);
	if (ingredient == INGREDIENT.SAUCE) {
	    draw_sprite_ext(spr_sauce_brush, 0,
	        surf_x, surf_y,
	        5, 5, rand_angle, c_white, 0.9);
	} else if (ingredient == INGREDIENT.SPECIALSAUCE) {
	    draw_sprite_ext(spr_specialsauce_brush, 0,
	        surf_x, surf_y,
	        5, 5, rand_angle, c_white, 0.9);
	} else {
	    draw_sprite_ext(spr_cheese_brush, 0,
	        surf_x, surf_y,
	        5, 5, rand_angle, c_white, 0.9);
	}
	surface_reset_target();
}

function Pizza_Cook(pizza) {
    var scale = pizza.surf_size / 1000; // scale to fill surface (1000 = sprite base size)
    
    if (surface_exists(pizza.surf_sauce)) {
        var spr_sauce = spr_sauce_uncooked;
        if (pizza.cook_state == PIZZA_COOK.COOKED) spr_sauce = spr_sauce_cooked;
        if (pizza.cook_state == PIZZA_COOK.BURNT)  spr_sauce = spr_sauce_burnt;
        
        surface_set_target(pizza.surf_sauce);
        gpu_set_blendmode_ext(bm_dest_colour, bm_zero);
        draw_sprite_ext(spr_sauce, 0,
            pizza.surf_size * 0.5,
            pizza.surf_size * 0.5,
            scale, scale, 0, c_white, 1);
        gpu_set_blendmode(bm_normal);
        surface_reset_target();
    }
    
    if (surface_exists(pizza.surf_cheese)) {
        var spr_chees = spr_cheese_uncooked;
        if (pizza.cook_state == PIZZA_COOK.COOKED) spr_chees = spr_cheese_cooked;
        if (pizza.cook_state == PIZZA_COOK.BURNT)  spr_chees = spr_cheese_burnt;
        
        surface_set_target(pizza.surf_cheese);
        gpu_set_blendmode_ext(bm_dest_colour, bm_zero);
        draw_sprite_ext(spr_chees, 0,
            pizza.surf_size * 0.5,
            pizza.surf_size * 0.5,
            scale, scale, 0, c_white, 1);
        gpu_set_blendmode(bm_normal);
        surface_reset_target();
    }
    
    with (oTopping) {
        if (parent_pizza == pizza) {
            cook_state = pizza.cook_state;
        }
    }
}

function PizzaIsSealed(_pizza) {
    if (_pizza == noone || !instance_exists(_pizza)) return true;  // no pizza = nothing to modify
    return _pizza.is_locked;
}

function PizzaReset(_pizza) {
    if (_pizza == noone || !instance_exists(_pizza)) return;

    var _target = _pizza;
    with (oTopping) {
        if (parent_pizza == _target) instance_destroy();
    }

    if (surface_exists(_pizza.surf_sauce)) {
        surface_set_target(_pizza.surf_sauce);
        draw_clear_alpha(c_white, 0);
        surface_reset_target();
    }
    if (surface_exists(_pizza.surf_cheese)) {
        surface_set_target(_pizza.surf_cheese);
        draw_clear_alpha(c_white, 0);
        surface_reset_target();
    }

    _pizza.sauce_globs    = 0;
    _pizza.cheese_globs   = 0;
    _pizza.topping_counts = array_create(INGREDIENT.COUNT, 0);
    _pizza.cook_state     = PIZZA_COOK.UNCOOKED;
    _pizza.glob_timer     = 0;
    _pizza.is_locked      = false;

    global.special_sauce_used = false;
    global.pizza_ready        = false;

    var _cook = instance_find(oCookButton, 0);
    if (instance_exists(_cook)) _cook.cook_stage = 0;   // else fresh dough cooks straight to burnt
}

function PizzaBoxSeal(_box, _pizza) {
    if (instance_exists(_pizza)) {
        _pizza.x = _box.x;
        _pizza.y = _box.y;
        _pizza.vx = 0;
        _pizza.vy = 0;
        _pizza.can_be_picked_up = false;
        _pizza.can_be_clicked   = false;
        _pizza.is_locked        = true;
        _box.pizza_ref = _pizza;
    }
    _box.box_state    = "closed";
    _box.sprite_index = spr_pizza_box_closed;
    _box.depth        = -99997;
    _box.can_be_picked_up = true;
    _box.can_be_clicked   = false;
}