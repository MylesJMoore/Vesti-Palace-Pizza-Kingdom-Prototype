function PizzaScripts(pizza, world_x, world_y, ingredient) {
    var surf = -1;
    
    if (ingredient == INGREDIENT.SAUCE) {
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
	} else {
	    draw_sprite_ext(spr_cheese_brush, 0,
	        surf_x, surf_y,
	        5, 5, rand_angle, c_white, 0.9);
	}
	surface_reset_target();
}

function Pizza_Cook(pizza) {
    // Sauce surface — redraw with cooked sprite
    if (surface_exists(pizza.surf_sauce)) {
        var spr_sauce = spr_sauce_uncooked;
        if (pizza.cook_state == PIZZA_COOK.COOKED) spr_sauce = spr_sauce_cooked;
        if (pizza.cook_state == PIZZA_COOK.BURNT)  spr_sauce = spr_sauce_burnt;
        
        // We need to re-tint the existing surface
        // Simplest: draw cooked sprite over the surface using multiply blend
        surface_set_target(pizza.surf_sauce);
        gpu_set_blendmode_ext(bm_dest_colour, bm_zero);
        draw_sprite_ext(spr_sauce, 0,
            pizza.surf_size * 0.5,
            pizza.surf_size * 0.5,
            1, 1, 0, c_white, 1);
        gpu_set_blendmode(bm_normal);
        surface_reset_target();
    }
    
    // Cheese surface
    if (surface_exists(pizza.surf_cheese)) {
        var spr_chees = spr_cheese_uncooked;
        if (pizza.cook_state == PIZZA_COOK.COOKED) spr_chees = spr_cheese_cooked;
        if (pizza.cook_state == PIZZA_COOK.BURNT)  spr_chees = spr_cheese_burnt;
        
        surface_set_target(pizza.surf_cheese);
        gpu_set_blendmode_ext(bm_dest_colour, bm_zero);
        draw_sprite_ext(spr_chees, 0,
            pizza.surf_size * 0.5,
            pizza.surf_size * 0.5,
            1, 1, 0, c_white, 1);
        gpu_set_blendmode(bm_normal);
        surface_reset_target();
    }
    
    // Update toppings cook state
    with (oTopping) {
        if (parent_pizza == pizza) {
            cook_state = pizza.cook_state;
        }
    }
}