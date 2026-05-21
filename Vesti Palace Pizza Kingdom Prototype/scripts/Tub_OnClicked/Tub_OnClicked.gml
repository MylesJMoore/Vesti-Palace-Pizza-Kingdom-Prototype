function Tub_OnClicked(tub) {
    var table = instance_find(oAssemblyTable, 0);
    if (!instance_exists(table)) return;

    if (table.active_ingredient == tub.ingredient_type) {
        table.active_ingredient = INGREDIENT.NONE;
        global.hand_mode = HAND_MODE.GRAB;
        table.is_painting = false;
    } else {
        table.active_ingredient = tub.ingredient_type;
        global.hand_mode = HAND_MODE.PAINT;
    }
}