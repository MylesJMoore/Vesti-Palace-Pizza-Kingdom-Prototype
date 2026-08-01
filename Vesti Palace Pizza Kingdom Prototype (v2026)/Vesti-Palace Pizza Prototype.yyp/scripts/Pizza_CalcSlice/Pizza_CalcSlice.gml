function Pizza_CalcSlice(sauce_globs, cheese_globs, cook_state, topping_count, topping_counts, order) {
    var _score = 100;

    // Sauce coverage
    var _sauce_pct = clamp(sauce_globs / 300, 0, 1);
    var _sauce_ideal = 0.7;
    var _sauce_dev = abs(_sauce_pct - _sauce_ideal);
    if _sauce_dev > 0.12 { _score -= clamp((_sauce_dev - 0.12) / 0.88 * 40, 0, 40); }

    // Cheese coverage
    var _cheese_pct = clamp(cheese_globs / 300, 0, 1);
    var _cheese_ideal = 0.75;
    var _cheese_dev = abs(_cheese_pct - _cheese_ideal);
    if _cheese_dev > 0.12 { _score -= clamp((_cheese_dev - 0.12) / 0.88 * 40, 0, 40); }

    // Cook state
    if cook_state == PIZZA_COOK.BURNT    _score -= 35;
    if cook_state == PIZZA_COOK.UNCOOKED _score -= 20;

    // Toppings (quality: too few / too many)
    if topping_count == 0  _score -= 15;
    if topping_count > 15  _score -= 10;

    _score = clamp(_score, 0, 100);

    var _base_scoops = floor(_score / 10);         // 0-10 from quality
    var _base_money  = 5 + floor(_score * 0.5);    // base $5 + quality tip

    // --- ORDER SATISFACTION (accuracy) — proportion of requirements met ---
    var _satisfaction = -1;
    var _sat_scoops = 0;
    var _sat_money  = 0;
	if (!is_undefined(order) && !is_undefined(topping_counts)) {
	    var _req = 0;
	    var _met = 0;

	    // Sauce
	    if (order[INGREDIENT.SAUCE] > 0) {
	        _req++;
	        _met += clamp(_sauce_pct / _sauce_ideal, 0, 1);
	    } else if (_sauce_pct > 0.1) {
	        _met -= 0.5;                        // unwanted sauce present
	    }
	    // Cheese
	    if (order[INGREDIENT.CHEESE] > 0) {
	        _req++;
	        _met += clamp(_cheese_pct / _cheese_ideal, 0, 1);
	    } else if (_cheese_pct > 0.1) {
	        _met -= 0.5;                        // unwanted cheese present
	    }
	    // Toppings
	    var _pool = scr_orderable_ingredients();
	    for (var _i = 0; _i < array_length(_pool); _i++) {
	        var _ing  = _pool[_i];
	        var _want = order[_ing];
	        var _have = topping_counts[_ing];
	        if (_want > 0) {
	            _req++;
	            _met += 1 - clamp(abs(_have - _want) / _want, 0, 1);
	        } else if (_have > 0) {
	            _met -= 0.4;                    // wrong topping present
	        }
	    }

	    _satisfaction = (_req > 0) ? clamp(_met / _req * 100, 0, 100) : 100;
	    _sat_scoops = floor(_satisfaction / 10);
	    _sat_money  = floor(_satisfaction * 0.3);
	}

    var _scoops_earned = _base_scoops + _sat_scoops;
    var _money_earned  = _base_money  + _sat_money;
	
	// --- Excellence / combo bonus (earned payoff) ---
    var _bonus_scoops = 0;
    var _bonus_money  = 0;
    var _bonus_label  = "";

    var _great_quality = (_score >= 80);          // S / S+
    var _great_order   = (_satisfaction >= 95);  // perfect match (only true if an order existed)

    if (_great_order && _score >= 97) {
        _bonus_scoops = 50; _bonus_money = 75; _bonus_label = "PERFECT PIE!";
    } else if (_great_order && _great_quality) {
        _bonus_scoops = 30; _bonus_money = 50; _bonus_label = "MASTERPIECE!";
    } else if (_great_order) {
        _bonus_scoops = 20; _bonus_money = 30; _bonus_label = "PERFECT ORDER!";
    } else if (_great_quality) {
        _bonus_scoops = 15; _bonus_money = 20; _bonus_label = "GORGEOUS PIZZA!";
    }
	
	// Rank table — index-based so order accuracy can bump it
    var _ranks = ["F-","F","F+","D-","D","D+","C","B","A","S","S+"];
    var _ri;
    if      (_score >= 97) _ri = 10;
    else if (_score >= 90) _ri = 9;
    else if (_score >= 80) _ri = 8;
    else if (_score >= 70) _ri = 7;
    else if (_score >= 60) _ri = 6;
    else if (_score >= 50) _ri = 5;
    else if (_score >= 40) _ri = 4;
    else if (_score >= 30) _ri = 3;
    else if (_score >= 20) _ri = 2;
    else if (_score >= 10) _ri = 1;
    else                   _ri = 0;

    // Order-accuracy bump (only when an order was actually placed)
    var _bump = 0;
    if (_satisfaction >= 0) {
        if      (_satisfaction >= 100) _bump =  2;   // exact order  → +2 tiers
        else if (_satisfaction >= 80)  _bump =  1;   // close        → +1 tier
        else if (_satisfaction <  40)  _bump = -1;   // wrong pizza  → -1 tier  (optional)
    }
    _ri = clamp(_ri + _bump, 0, array_length(_ranks) - 1);

    var _rank = _ranks[_ri];

    _scoops_earned += _bonus_scoops;
    _money_earned  += _bonus_money;

    // Special sauce premium (bypasses everything)
    if (global.special_sauce_used) {
        _scoops_earned += 100;
        _money_earned  += 50;
        global.special_sauce_used = false;
    }

    return {
        slice_score:       _score,
        rank:              _rank,
        scoops_earned:     _scoops_earned,   // TOTAL — your reward code stays unchanged
        money_earned:      _money_earned,
		bonus_label:	   _bonus_label,
		bonus_scoops:      _bonus_scoops,
		bonus_money:       _bonus_money,
        base_scoops:       _base_scoops,     // breakdown for the score screen:
        base_money:        _base_money,
        satisfaction:      _satisfaction,    // 0-100, or -1 if no order
        sat_bonus_scoops:  _sat_scoops, //NOT USED
        sat_bonus_money:   _sat_money   //NOT USED
    };
}