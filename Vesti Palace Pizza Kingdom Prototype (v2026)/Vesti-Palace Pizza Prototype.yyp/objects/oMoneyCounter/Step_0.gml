// Check all draggable coins (oInteractable children with coin_value)
with (oInteractable) {
    if variable_instance_exists(id, "coin_value") && !held {
        var dx = x - other.x;
        var dy = y - other.y;
        if dx*dx + dy*dy < other.drop_radius * other.drop_radius {
            other.bank_coin(id);
        }
    }
}

// Update popups
for (var _i = array_length(popups) - 1; _i >= 0; _i--) {
    popups[_i].y -= 1.5;
    popups[_i].life--;
    if popups[_i].life <= 0 {
        array_delete(popups, _i, 1);
    }
}