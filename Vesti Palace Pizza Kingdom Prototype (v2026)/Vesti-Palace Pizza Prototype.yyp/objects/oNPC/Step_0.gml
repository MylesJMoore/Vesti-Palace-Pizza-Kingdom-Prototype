if !instance_exists(obj_dialogue_manager) exit;
var _mgr = obj_dialogue_manager;

// NPC Idle Bob
bob_phase += bob_speed;
y = base_y + sin(bob_phase) * bob_amount;   // (restored)

// JUST ENDED GUARD
if _mgr.dialogue_just_ended exit;

// -------------------------
// Pick dialogue node + sprite
// -------------------------
if (npc_id == "counter_customer") {
    sprite_index  = scr_customer_sprite(global.current_customer);
    // Greet until they've heard the order; the "still waiting" line after.
    dialogue_node = global.order_revealed
        ? scr_customer_wait_node(global.current_customer)
        : scr_customer_greet_node(global.current_customer);
} else {
    var _met_flag    = "met_" + npc_id;
    var _first_node  = npc_id + "_greet";
    var _return_node = npc_id + "_greet_return";
    dialogue_node = dialogue_get_flag(_met_flag, false) ? _return_node : _first_node;
}

// -------------------------
// Track arrival at the counter — MUST run before any early exits below,
// so was_in_range still updates to false when the player walks away.
// -------------------------
var _dist        = point_distance(x, y, obj_player.x, obj_player.y);
var _in_range    = (_dist < trigger_range);
var _just_arrived = _in_range && !was_in_range;
was_in_range     = _in_range;

// PROMPT VISIBILITY
if instance_exists(prompt_inst) {
    prompt_inst.visible_target = _in_range && !_mgr.active;
}

// FLAG TRACKING — catch the moment dialogue ends
if dialogue_was_active && !_mgr.active {
    dialogue_set_flag("met_" + npc_id, true);
    dialogue_was_active = false;
    if (npc_id == "counter_customer") global.order_revealed = true;
}

if _mgr.active exit;
if !_in_range exit;

// Only the closest NPC triggers
var _closest = noone;
var _closest_dist = 999999;
with (oNPC) {
    var _d = point_distance(x, y, obj_player.x, obj_player.y);
    if _d < _closest_dist {
        _closest_dist = _d;
        _closest = id;
    }
}
if _closest != id exit;

// -------------------------
// TRIGGER
// -------------------------
if (trigger_type == "auto") {
    if (npc_id == "counter_customer") {
        // Fire once each time the player arrives at the counter.
        // order_revealed (set above) decides greet vs waiting line.
        if (_just_arrived) {
            dialogue_start(dialogue_node);
            dialogue_was_active = true;
        }
    } else if (!triggered_auto) {
        triggered_auto = true;
        dialogue_start(dialogue_node);
        dialogue_was_active = true;
    }
}

// PRESS trigger (unchanged — still commented; leave as-is unless you want press)
if trigger_type == "press" {
    if keyboard_check_pressed(ord("E")) {
        //dialogue_start(dialogue_node);
        //dialogue_was_active = true;
    }
}