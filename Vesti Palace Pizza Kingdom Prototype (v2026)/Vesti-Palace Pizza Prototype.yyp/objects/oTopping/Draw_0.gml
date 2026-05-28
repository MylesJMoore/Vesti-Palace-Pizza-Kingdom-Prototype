var spr = -1;

switch (ingredient_type) {
    case INGREDIENT.PEPPERONI:
        if (cook_state == PIZZA_COOK.UNCOOKED) spr = spr_pepperoni_uncooked;
        if (cook_state == PIZZA_COOK.COOKED)   spr = spr_pepperoni_cooked;
        if (cook_state == PIZZA_COOK.BURNT)    spr = spr_pepperoni_burnt;
        break;
    case INGREDIENT.MUSHROOM:
        if (variant == 0) {
            if (cook_state == PIZZA_COOK.UNCOOKED) spr = spr_mushroom_uncookedL;
            if (cook_state == PIZZA_COOK.COOKED)   spr = spr_mushroom_cookedL;
            if (cook_state == PIZZA_COOK.BURNT)    spr = spr_mushroom_burntL;
        } else {
            if (cook_state == PIZZA_COOK.UNCOOKED) spr = spr_mushroom_uncookedR;
            if (cook_state == PIZZA_COOK.COOKED)   spr = spr_mushroom_cookedR;
            if (cook_state == PIZZA_COOK.BURNT)    spr = spr_mushroom_burntR;
        }
        break;
    case INGREDIENT.GLASS:
        switch (variant) {
            case 0: spr = spr_glass_1; break;
            case 1: spr = spr_glass_2; break;
            case 2: spr = spr_glass_3; break;
            case 3: spr = spr_glass_4; break;
            case 4: spr = spr_glass_5; break;
            case 5: spr = spr_glass_6; break;
            case 6: spr = spr_glass_7; break;
            case 7: spr = spr_glass_8; break;
        }
        break;
}

if (spr != -1) {
    draw_sprite_ext(spr, 0,
        x, y,
        image_xscale, image_yscale,
        image_angle,
        c_white, image_alpha);
}