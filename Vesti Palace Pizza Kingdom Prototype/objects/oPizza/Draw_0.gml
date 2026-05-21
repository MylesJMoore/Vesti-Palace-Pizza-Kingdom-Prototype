// held shadow (copied from oInteractable Draw)
if (held) {
    draw_sprite_ext(
        sprite_index, image_index,
        x + 4, y + 6,
        image_xscale * 0.98, image_yscale * 0.98,
        image_angle,
        c_black,
        0.35
    );
}

// --------------------
// BASE
// --------------------
var spr_base = spr_base_uncooked;
if (cook_state == PIZZA_COOK.COOKED) spr_base = spr_base_cooked;
if (cook_state == PIZZA_COOK.BURNT)  spr_base = spr_base_burnt;

draw_sprite_ext(
    spr_base, 0,
    x, y,
    image_xscale, image_yscale,
    image_angle,
    c_white, image_alpha
);

// --------------------
// SAUCE
// --------------------
if (sauce_coverage > 0.05) {
    var spr_sauce = spr_sauce_uncooked;
    if (cook_state == PIZZA_COOK.COOKED) spr_sauce = spr_sauce_cooked;
    if (cook_state == PIZZA_COOK.BURNT)  spr_sauce = spr_sauce_burnt;

    draw_sprite_ext(
        spr_sauce, 0,
        x, y,
        image_xscale, image_yscale,
        image_angle,
        c_white, image_alpha
    );
}

// --------------------
// CHEESE
// --------------------
if (cheese_coverage > 0.05) {
    var spr_cheese = spr_cheese_uncooked;
    if (cook_state == PIZZA_COOK.COOKED) spr_cheese = spr_cheese_cooked;
    if (cook_state == PIZZA_COOK.BURNT)  spr_cheese = spr_cheese_burnt;

    draw_sprite_ext(
        spr_cheese, 0,
        x, y,
        image_xscale, image_yscale,
        image_angle,
        c_white, image_alpha
    );
}

// --------------------
// TOPPINGS
// --------------------
var count = ds_list_size(toppings);

for (var i = 0; i < count; i++) {
    var top = toppings[| i];
    var spr_top = -1;

    if (top.type == INGREDIENT.PEPPERONI) {
        if (cook_state == PIZZA_COOK.UNCOOKED) spr_top = spr_pepperoni_uncooked;
        if (cook_state == PIZZA_COOK.COOKED)   spr_top = spr_pepperoni_cooked;
        if (cook_state == PIZZA_COOK.BURNT)    spr_top = spr_pepperoni_burnt;
    }
    else if (top.type == INGREDIENT.MUSHROOM) {
        if (top.variant == 0) {
            if (cook_state == PIZZA_COOK.UNCOOKED) spr_top = spr_mushroom_uncookedL;
            if (cook_state == PIZZA_COOK.COOKED)   spr_top = spr_mushroom_cookedL;
            if (cook_state == PIZZA_COOK.BURNT)    spr_top = spr_mushroom_burntL;
        } else {
            if (cook_state == PIZZA_COOK.UNCOOKED) spr_top = spr_mushroom_uncookedR;
            if (cook_state == PIZZA_COOK.COOKED)   spr_top = spr_mushroom_cookedR;
            if (cook_state == PIZZA_COOK.BURNT)    spr_top = spr_mushroom_burntR;
        }
    }
    else if (top.type == INGREDIENT.GLASS) {
        switch (top.variant) {
            case 0: spr_top = spr_glass_1; break;
            case 1: spr_top = spr_glass_2; break;
            case 2: spr_top = spr_glass_3; break;
            case 3: spr_top = spr_glass_4; break;
            case 4: spr_top = spr_glass_5; break;
            case 5: spr_top = spr_glass_6; break;
            case 6: spr_top = spr_glass_7; break;
            case 7: spr_top = spr_glass_8; break;
        }
    }

    if (spr_top != -1) {
        draw_sprite_ext(
            spr_top, 0,
            top.x, top.y,
            image_xscale, image_yscale,
            image_angle,
            c_white, image_alpha
        );
    }
}