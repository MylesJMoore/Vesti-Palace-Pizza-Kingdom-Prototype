function Pizza_CalcSlice(sauce_globs, cheese_globs, cook_state, topping_count) {
    var _score = 100;
    
    // Sauce coverage
    var _sauce_pct = clamp(sauce_globs / 300, 0, 1);
    var _sauce_ideal = 0.8;
    var _sauce_dev = abs(_sauce_pct - _sauce_ideal);
    if _sauce_dev > 0.12 {
        _score -= clamp((_sauce_dev - 0.12) / 0.88 * 40, 0, 40);
    }
    
    // Cheese coverage
    var _cheese_pct = clamp(cheese_globs / 300, 0, 1);
    var _cheese_ideal = 0.85;
    var _cheese_dev = abs(_cheese_pct - _cheese_ideal);
    if _cheese_dev > 0.12 {
        _score -= clamp((_cheese_dev - 0.12) / 0.88 * 40, 0, 40);
    }
    
    // Cook state
    if cook_state == PIZZA_COOK.BURNT    _score -= 35;
    if cook_state == PIZZA_COOK.UNCOOKED _score -= 20;
    
    // Toppings
    if topping_count == 0  _score -= 15;
    if topping_count > 15  _score -= 10;
    
    _score = clamp(_score, 0, 100);
    
    // Extended rank table
    var _rank = "F-";
    if _score >= 97      _rank = "S+";
    else if _score >= 90 _rank = "S";
    else if _score >= 80 _rank = "A";
    else if _score >= 70 _rank = "B";
    else if _score >= 60 _rank = "C";
    else if _score >= 50 _rank = "D+";
    else if _score >= 40 _rank = "D";
    else if _score >= 30 _rank = "D-";
    else if _score >= 20 _rank = "F+";
    else if _score >= 10 _rank = "F";
    // 0-9 = F-
    
    return { slice_score: _score, rank: _rank };
}