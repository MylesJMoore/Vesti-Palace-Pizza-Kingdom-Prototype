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
	case INGREDIENT.EYEBALLS:
        if (cook_state == PIZZA_COOK.COOKED) {
            spr = spr_eyeball_cooked;
        } else if (cook_state == PIZZA_COOK.BURNT) {
            spr = spr_eyeball_burnt;
        } else {
            switch (variant) {   // raw — one of the 8 looks
                case 0: spr = spr_eyeball_1; break;
                case 1: spr = spr_eyeball_2; break;
                case 2: spr = spr_eyeball_3; break;
                case 3: spr = spr_eyeball_4; break;
                case 4: spr = spr_eyeball_5; break;
                case 5: spr = spr_eyeball_6; break;
                case 6: spr = spr_eyeball_7; break;
                case 7: spr = spr_eyeball_8; break;
            }
        }
        break;
	case INGREDIENT.TEETH:
        switch (variant) {
            case 0: // spr_teeth_1 -> A
                if      (cook_state == PIZZA_COOK.COOKED) spr = spr_teeth_cooked_a;
                else if (cook_state == PIZZA_COOK.BURNT)  spr = spr_teeth_burnt_a;
                else                                      spr = spr_teeth_1;
                break;
            case 1: // spr_teeth_2 -> G
                if      (cook_state == PIZZA_COOK.COOKED) spr = spr_teeth_cooked_g;
                else if (cook_state == PIZZA_COOK.BURNT)  spr = spr_teeth_burnt_g;
                else                                      spr = spr_teeth_2;
                break;
            case 2: // spr_teeth_3 -> B
                if      (cook_state == PIZZA_COOK.COOKED) spr = spr_teeth_cooked_b;
                else if (cook_state == PIZZA_COOK.BURNT)  spr = spr_teeth_burnt_b;
                else                                      spr = spr_teeth_3;
                break;
            case 3: // spr_teeth_4 -> H
                if      (cook_state == PIZZA_COOK.COOKED) spr = spr_teeth_cooked_h;
                else if (cook_state == PIZZA_COOK.BURNT)  spr = spr_teeth_burnt_h;
                else                                      spr = spr_teeth_4;
                break;
            case 4: // spr_teeth_5 -> C
                if      (cook_state == PIZZA_COOK.COOKED) spr = spr_teeth_cooked_c;
                else if (cook_state == PIZZA_COOK.BURNT)  spr = spr_teeth_burnt_c;
                else                                      spr = spr_teeth_5;
                break;
            case 5: // spr_teeth_6 -> F
                if      (cook_state == PIZZA_COOK.COOKED) spr = spr_teeth_cooked_f;
                else if (cook_state == PIZZA_COOK.BURNT)  spr = spr_teeth_burnt_f;
                else                                      spr = spr_teeth_6;
                break;
            case 6: // spr_teeth_7 -> D
                if      (cook_state == PIZZA_COOK.COOKED) spr = spr_teeth_cooked_d;
                else if (cook_state == PIZZA_COOK.BURNT)  spr = spr_teeth_burnt_d;
                else                                      spr = spr_teeth_7;
                break;
            case 7: // spr_teeth_8 -> E
                if      (cook_state == PIZZA_COOK.COOKED) spr = spr_teeth_cooked_e;
                else if (cook_state == PIZZA_COOK.BURNT)  spr = spr_teeth_burnt_e;
                else                                      spr = spr_teeth_8;
                break;
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