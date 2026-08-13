# Vesti Palace Pizza Kingdom — State V3

Source of truth for this document: the actual GML source under
`Vesti Palace Pizza Kingdom Prototype (v2026)\Vesti-Palace Pizza Prototype.yyp\`
(a directory despite the `.yyp` extension — contains `objects/`, `scripts/`, `rooms/`, `sprites/`, `sounds/`, `datafiles/`).
GameMaker Studio 2 / GML project, IDE version `2026.0.0.15`.

There is a second, older project tree at
`...\Vesti-Palace Pizza Prototype\Vesti Palace Kingdom Prototype\` (no `(v2026)` suffix, no `.yyp` wrapper)
containing its own copy of `Pizza_Constants.gml` and pizza scripts. **It is not part of the live `.yyp`** and was excluded from this audit. Don't grep it by accident.

This document is written for an AI (or dev) with zero prior context on the repo. Every claim below is backed by a real file/line; where something is dead, stubbed, or inconsistent, it's called out explicitly rather than smoothed over.

---

## 1. Architecture Overview

### 1.1 Rooms and room flow

Room order (`RoomOrderNodes` in the `.yyp`, which is also the `room_goto_next()` sequence):

1. **Initialization** — bootstraps the persistent controllers, then immediately calls `room_goto_next()` in `iGame`'s Create event. Contains `iGame`, `oJukebox`, `oHUD`, `obj_player`, `obj_dialogue_manager`, `oUIRoomController` — i.e. every persistent singleton is placed here and nowhere else.
2. **MainMenu** — title screen. Contains `oCursor`, `obj_brickwall`, and four draggable "window" icons: `oWindowStart`, `oWindowPalace`, `oWindowPizzaKingdom`, `oWindowVesti`. Music: `snd_music_title`.
3. **VestiPalace** — top-down RPG overworld hub room (`global.game_mode = "RPG"`). Contains `obj_wall` × 8, `obj_warp_block` × 5. Music: `snd_music_overworld`.
4. **VestiOffice** — second RPG room, also `"RPG"` mode. `obj_wall` × 11, `obj_warp_block` × 2. Music: `snd_music_office`.
5. **CounterPizzaDelivery** — delivery/scoring room. `oSliceScore`, `oPizzaDropZone`, `oHand`, `oCustomerDelivery`, `oCursor`, `obj_counter`, `obj_brickwall`. Has a `RoomCreationCode.gml` that spawns a closed `oPizzaBox` if `global.pizza_ready`. No music cue of its own (relies on whatever was already playing).
6. **CounterCustomer** — where the player talks to the customer and receives the order. `oNPC` (the `counter_customer` instance), `obj_test_background`.
7. **AssemblyLine** — **legacy/orphaned pizza-making room.** Never reached by any `room_goto` in the codebase (grep-confirmed). Contains `oAssemblyTable`, `oTub_Sauce`/`oTub_Pepperoni`/`oTub_Cheese`, `oPizza`, `oHand` × 2, `obj_counter`, `obj_brickwall`.
8. **CounterMoney** — coin-banking minigame room. `oMoneyCounter`, `oPenny`, `oQuarter`, `oKey`, `oCursor`, `obj_money_counter` (unused, see §6), `obj_brickwall`.
9. **Computer** — a "computer desktop" screen reached from the RPG rooms. `oWindowVesti`, `oWindowPizzaKingdom`, `oWindowPalace`, `oCursor`, `obj_dialogue_test` (empty stub), `obj_computer_desktop`, `obj_brickwall`. Music: `snd_music_computer`.
10. **AssemblyLineV2** — **the live pizza-making room.** `oBin` × 6, `oPizzaV2`, `oPizzaBox`, `oPizzaBaseRim`, `oHUD`, `oHand`, `oCookButton`, `oCamera`. Music: `snd_music_assembly`.

**Room-mode driver** — `objects\iGame\Step_0.gml` runs every frame and sets `global.game_mode`:
```gml
if(room == VestiOffice || room == VestiPalace) {
    global.game_mode = "RPG";
} else {
    global.game_mode = "UI";
}
```
When in `"UI"` mode, `obj_player` is hidden and `global.player_can_move` is forced false; in `"RPG"` mode it's shown and movable. `global.return_room` is recorded whenever the game transitions from an RPG room into a non-RPG room, and `oUIRoomController\Step_0.gml` sends the player back to it on `Esc`/`C` while in a non-MainMenu UI room.

**Meta-navigation ("computer desktop") flow:** `MainMenu` and `Computer` both place the same four draggable window icons (`oWindowStart`/`oWindowPalace`/`oWindowPizzaKingdom`/`oWindowVesti`, all children of `oInteractable`). Only `oWindowStart` sets `clickable_main_menu_start = true` in its Create event; the generic cursor object (`oCursor\Step_0.gml`) checks this flag on drop and does `room_goto(VestiPalace)`. **The other three window icons (`oWindowPalace`/`oWindowPizzaKingdom`/`oWindowVesti`) have no Step/Draw events of their own and no other code reads them** — dragging them around does nothing beyond the inherited physics. This looks like an intentionally-scoped "start button" that was never extended to the other icons, or a stub for a desktop-icon system that never got wired up.

Actual room transitions found in code (`room_goto(...)`):
- `oCursor\Step_0.gml`: `room_goto(VestiPalace)` on dropping `oWindowStart`.
- `obj_warp\Step_0.gml`: `room_goto(target_room); obj_player.x = target_x; ...` — the RPG-room warp mechanism (see §1.3).
- `objects\oCustomerDelivery\Step_0.gml`: `room_goto(VestiPalace)` after the score screen is dismissed (click), which also rotates to a new customer via `scr_customer_new()`.
- `iGame\Create_0.gml`: `room_goto_next()` once at boot, to leave `Initialization`.

### 1.2 Global / persistent controllers

Persistence is a per-object flag (`"persistent":true` in the object's `.yy`), not per-instance. Exactly **6 objects** are persistent, and all 6 are placed only in the `Initialization` room (they survive every subsequent room change automatically):

| Object | Role |
|---|---|
| `iGame` | Boot-time global-state initializer + room-mode driver. See §1.4. |
| `oHUD` | Always-on-top status bar (money/SCOOPS/objective/order ticket). Singleton-guarded in its own Create. |
| `oJukebox` | Music-channel manager (`jukebox_play`/`jukebox_stop`/`jukebox_duck`). Singleton-guarded. |
| `oUIRoomController` | `Esc`/`C` → return to `global.return_room` while in a non-MainMenu UI room. |
| `obj_dialogue_manager` | The dialogue engine singleton (loads `vesti_dialogue.json`, drives typewriter/choices). Singleton-guarded. |
| `obj_player` | The RPG-room player avatar. Singleton-guarded (self-destroys duplicates in `Step_0.gml`). |

Everything else in the project is **non-persistent** — it exists only while its room is loaded, and per-pizza/per-session gameplay objects (`oPizzaV2`, `oHand`, `oBin`, etc.) are recreated fresh every time `AssemblyLineV2` is entered.

**Naming trap:** `oGlob` sounds like it might be a "global" controller. It is not — it's a small fading sprite particle dropped at the brush point during sauce/cheese painting (`objects\oGlob\*.gml`, inherits nothing global-related). Don't confuse it with `global.*` variables or with `oGlobSplat` (a separate, more general particle object used for topping splats, box sparkles, and confetti-adjacent bursts).

### 1.3 State persistence across rooms

There is **no save/load system** — no `ini_*`, `buffer_save`/`buffer_load` (except the one-time static `vesti_dialogue.json` read), `json_encode`/`decode` of game state, or any other on-disk persistence was found anywhere in the project. All state is `global.*` variables held in RAM for the process lifetime, reset only by relaunching the game (see §3.8).

Cross-room state carriers:
- **`global.*` variables** (full inventory in §4) — the primary mechanism. Set once in `iGame\Create_0.gml`, then mutated by whichever room's objects are currently active.
- **The 6 persistent objects** above — carry behavior/UI, not data per se (their own instance variables mostly re-derive from globals each frame).
- **RPG room warps** — `obj_warp_block` (placed in `VestiPalace`/`VestiOffice`) has a `Step_0.gml` that spawns a transient `obj_warp` instance when the player touches it: `obj_warp\Step_0.gml` does `room_goto(target_room); obj_player.x = target_x; obj_player.y = target_y; obj_player.face = target_face;`, and the `obj_warp` instance self-destroys once the room has actually changed (`Other_7.gml`: `if (room == target_room) && (image_index < 1) instance_destroy();`).
- **The pizza box "snapshot" pattern** — the closed pizza box does not carry itself between rooms as a live instance. Instead, `oPizzaBox\Step_0.gml` snapshots the pizza's stats into `global.pizza_sauce/cheese/cook/toppings/topping_counts` and sets `global.pizza_ready = true` when it snaps shut in `AssemblyLineV2`; `CounterPizzaDelivery`'s `RoomCreationCode.gml` then spawns a **fresh** `oPizzaBox` instance already in the `"closed"` state if `global.pizza_ready` is true. This is the only "cross-room object" pattern in the game, and it's implemented via a global-flag handoff, not object persistence.

### 1.4 `iGame` — the actual boot sequence

`objects\iGame\Create_0.gml` (full, this is the single source of truth for every global's initial value):
```gml
window_set_cursor(cr_none);
global.game_mode = "UI";
global.hand_mode = HAND_MODE.GRAB;
global.player_can_move = true;
if (!variable_global_exists("return_room")) { global.return_room = VestiOffice; }
last_room = room;
room_goto_next();

global.counter_min_x = 0;   global.counter_min_y = 400;
global.counter_max_x = 1362; global.counter_max_y = 680;

global.active_ingredient = INGREDIENT.NONE;
global.topping_depth = 0;

global.customer_queue = ["counter_customer", "counter_customer_2"];
global.current_customer = 0;

global.pizza_ready = false; global.pizza_sauce = 0; global.pizza_cheese = 0;
global.pizza_cook = 0; global.pizza_toppings = 0;

global.money = 0;
global.scoops = 0;              // cumulative reputation, 0-800
global.last_slice_score = 0;
global.last_rank = "-";
global.pizzas_made = 0;
global.player_name = "Myles";   // hardcoded, no name-entry UI exists anywhere
global.hud_visible = true;

global.current_customer = CUSTOMER.GURAMAHSH;
global.current_customer_sprite = CUSTOMER_SPRITES.spr_guramahsh;
global.current_order = array_create(INGREDIENT.COUNT, 0);
global.order_revealed = false;
global.order_served = false;
scr_customer_new();   // roll the first real customer + order
```
Two globals used elsewhere are **not** initialized here (an inconsistency worth knowing about): `global.special_sauce_used` is first set in every `oBin`'s own `Create_0.gml` (`global.special_sauce_used = false;`), and `global.pizza_topping_counts` is never explicitly initialized anywhere — it's first written by `oPizzaBox\Step_0.gml` (`global.pizza_topping_counts = pizza.topping_counts;`) at the moment a box is closed, so it would be `undefined` if ever read before the first pizza is boxed (nothing does read it that early in practice).

### 1.5 Object inheritance

Every draggable/clickable gameplay object descends from **`oInteractable`** (`objects\oInteractable\*.gml`), which provides: spring-follow-when-held physics, inertia/slide, boundary clamping (`drag_bounds_mode`: 0=none, 1=counter rect via `global.counter_min/max_x/y`, 2=full room), a subtle "Balatro wiggle" rotation while held, and a drop-shadow draw. Children: `oBin`, `oCondimentTub` (and its children `oTub_Cheese`/`oTub_Glass`/`oTub_Mushroom`/`oTub_Pepperoni`/`oTub_Sauce`), `oCookButton`, `oPizzaBox`, `oKey`, `oPenny`, `oPizza`, `oQuarter`, `oPizzaCompleted`, `oPizzaV2`, `oTopping`, `oWindowPalace`/`oWindowPizzaKingdom`/`oWindowStart`/`oWindowVesti`.

---

## 2. The Enums — the data-driven spine

All defined verbatim in `scripts\Pizza_Constants\Pizza_Constants.gml`:

```gml
enum PIZZA_COOK { UNCOOKED = 0, COOKED = 1, BURNT = 2 }

enum INGREDIENT { NONE = 0, SAUCE, CHEESE, PEPPERONI, MUSHROOM, GLASS, SPECIALSAUCE, COUNT }
// numeric values: NONE=0, SAUCE=1, CHEESE=2, PEPPERONI=3, MUSHROOM=4, GLASS=5, SPECIALSAUCE=6, COUNT=7
// SPECIALSAUCE was appended after GLASS (added later in dev), not grouped near SAUCE.

enum HAND_MODE { GRAB = 0, PAINT = 1 }

enum CUSTOMER { GURAMAHSH, SCARY_GUY, POET, FRANK, DR_YELLOW, MRS_CLOUD, COUNT }

#macro SAUCE_FULL    300
#macro SAUCE_IDEAL   0.80
#macro CHEESE_FULL   300
#macro CHEESE_IDEAL  0.85

enum CUSTOMER_SPRITES { spr_guramahsh, spr_scary_guy, spr_poet, spr_frank, spr_dr_yellow_guy, spr_mrs_cloud, spr_default_npc }
```

`CUSTOMER_SPRITES` is effectively **vestigial**: it's assigned exactly once as a placeholder (`iGame\Create_0.gml:58`) and every real lookup goes through `scr_customer_sprite()` instead, which returns actual sprite assets, not `CUSTOMER_SPRITES` ordinals.

`SAUCE_IDEAL`/`CHEESE_IDEAL` (0.80/0.85) are **not** what the live scorer uses — see §3.2's discrepancy note.

### 2.1 `INGREDIENT` — every switch/lookup keyed off it

| Function/table | File | Returns | Called from |
|---|---|---|---|
| `scr_topping_name(id)` | `ToppingScripts.gml` | Display name ("Vesti Pizza Sauce", "Special Sauce", "Cheese", "Pepperoni", "Mushroom", "Glass Shard") | `oHand\Draw_0.gml`, `scr_customer_functions.gml` (`scr_order_lines`), `oHUD\Draw_64.gml` (×2) |
| `scr_topping_icon(id)` | `ToppingScripts.gml` | Brush sprite (`spr_sauce_brush`/`spr_specialsauce_brush`/`spr_cheese_brush`/`spr_pepperoni_brush`/`spr_mushroom_brush`/`spr_glass_brush`) | `oHand\Draw_0.gml` (cursor sprite while painting) |
| `scr_topping_color(id)` | `ToppingScripts.gml` | HUD/label RGB (sauce red, cheese yellow, pepperoni orange, mushroom **and** specialsauce both `rgb(110,220,110)` green, glass light blue; no `NONE` case → falls to `c_white`) | `oHand\Draw_0.gml`, `oHUD\Draw_64.gml` |
| `scr_topping_cost(id)` | `ToppingScripts.gml` | `SAUCE=0, SPECIALSAUCE=0, CHEESE=0, PEPPERONI=1, MUSHROOM=2, GLASS=5` | `oHand\Step_0.gml` (spend gate + popup) |
| `scr_orderable_ingredients()` | `scr_customer_functions.gml` | `[PEPPERONI, MUSHROOM, GLASS]` (hardcoded array; SAUCE/CHEESE handled separately as "base layers"; SPECIALSAUCE never orderable) | `scr_order_new`, `scr_order_lines`, `Pizza_CalcSlice`, `oHUD\Draw_64.gml` |
| `PizzaScripts(pizza,x,y,ingredient)` | `PizzaScripts.gml` | Routes SAUCE/SPECIALSAUCE → `surf_sauce`, else (implicit CHEESE) → `surf_cheese`; stamps the matching brush sprite | `oHand\Step_0.gml` |
| `oHand::Step_0` limit table | `oHand\Step_0.gml` | `PEPPERONI→pizza.max_pepperoni, MUSHROOM→max_mushroom, GLASS→max_glass` (all 99) | topping placement gate |
| `oHand::Step_0` SFX table | `oHand\Step_0.gml` | `PEPPERONI→snd_sfx_topping_pepperoni, MUSHROOM→...mushroom, GLASS→...glass` | topping placement |
| `oHand::Step_0` variant table | `oHand\Step_0.gml` (+ duplicated in `Pizza_StampTopping.gml` for V1) | `MUSHROOM→irandom(1)` (L/R), `GLASS→irandom(7)` (8 shard sprites), else `0` | topping spawn |
| `oHand::Step_0` splat-color table | `oHand\Step_0.gml` | Pepperoni dark red, mushroom green, glass blue — **a second, different color table from `scr_topping_color`** (values diverge, e.g. pepperoni is orange in the HUD table but dark red in splats) | topping placement particles |
| `oTopping::Draw_0` / `oPizza::Draw_0` (legacy) | nested `switch(ingredient) { switch/if(cook_state) ... }` | Final sprite: pepperoni uncooked/cooked/burnt; mushroom L/R × 3 cook states; glass 1–8 by variant (no cook-state variants for glass) | every topping draw |
| Container instances (`oTub_*`, `oBin` × 6 room instances) | Create events / `InstanceCreationCode_*.gml` | Each hardcodes one `ingredient_type` + matching `sprite_index` | N/A — this is the enum-to-sprite table expressed as object data rather than a switch |

Also: `Tub_OnClicked(tub)` (legacy) and `oBin`'s inline `on_clicked` closure (live) both toggle `HAND_MODE`/`active_ingredient` when a container is clicked — see §3.1.

### 2.2 `PIZZA_COOK` — every switch/lookup keyed off it

No `switch` statement anywhere uses `PIZZA_COOK` — every site is an `if`/`==` chain. Two **independent, parallel cook-state drivers** exist:

1. **`oCookButton`** (live, V2) — click-to-advance: each click increments a per-button `cook_stage` (capped at 2) and assigns it directly to `pizza.cook_state`, then calls `Pizza_Cook(pizza)`.
2. **`oOvenStation`** (dead — placed in zero rooms) — timer-based: compares `current_time - cook_start_time` against `cook_time_needed`(6000ms)/`burn_time`(12000ms) every step.

`Pizza_Cook(pizza)` (`scripts\PizzaScripts\PizzaScripts.gml`) re-tints the **entire existing sauce/cheese surface** using a `gpu_set_blendmode_ext(bm_dest_colour, bm_zero)` multiply trick (stamps a full-surface cooked/burnt sprite over the existing alpha shape, rather than repainting individual dabs), then propagates `cook_state` onto every live `oTopping` belonging to that pizza.

Sprite-swap chains keyed on cook state exist independently in: `oTopping\Draw_0.gml` (per-ingredient), `oPizza\Draw_0.gml` (legacy: base/sauce-coverage/cheese-coverage/toppings, 4 separate chains), `oPizzaV2\Draw_0.gml` (base sprite only — its sauce/cheese cook-tinted sprite variables are computed but **never actually used** in the draw call, since sauce/cheese render as surfaces baked once by `Pizza_Cook`, not re-tinted per frame; likely vestigial code), `oPizzaBaseRim\Draw_0.gml` (crust rim, reads `oPizzaV2.cook_state` as an object-wide reference rather than a local copy — fragile if multiple `oPizzaV2` instances ever existed).

Scoring penalty (both scorers): `BURNT → -35`, `UNCOOKED → -20`.

### 2.3 `HAND_MODE` — every read/write site

No switch exists; always `if`/`==`. `GRAB` (default, drag items) vs `PAINT` (topping/sauce/cheese application mode). Set to `PAINT` when a bin/tub is clicked (deselect toggles back to `GRAB`), forced back to `GRAB` on: right-click cancel (`oHand\Step_0.gml`), room-exit cleanup (`oHand\Other_4.gml`), pizza-box on_clicked deselect, delivery-room reset (`oCustomerDelivery\Step_0.gml`), and game boot. `oPizzaV2\Step_0.gml` locks the pizza's physics (`vx=vy=0`) while `HAND_MODE.PAINT` is active so it can't be dragged mid-stroke.

### 2.4 `CUSTOMER` / `CUSTOMER_SPRITES` — every switch/lookup keyed off it

All in `scripts\scr_customer_functions\scr_customer_functions.gml` unless noted:

| Function | Returns |
|---|---|
| `scr_customer_name(id)` | "Guramahsh" / "Nice Scary Guy" / "Tortured Hungry Poet" / "Frank" / "Dr. Yellow Guy" / "Mrs. Cloud", default "Customer" |
| `scr_customer_sprite(id)` | The **actual sprite asset** (`spr_guramahsh` etc.), default `spr_default_npc` — not a `CUSTOMER_SPRITES` ordinal |
| `scr_customer_greet_node(id)` | Dialogue node id `"greet_<name>"`, used while `global.order_revealed == false` |
| `scr_customer_wait_node(id)` (in `scr_dialogue_functions.gml`, not the customer file) | Dialogue node id `"wait_<name>"`, used after the order has been revealed |
| `scr_customer_new()` | Not a switch — RNG rotator: `irandom(CUSTOMER.COUNT-1)` in a `do...until (_next != _prev)` loop, guarantees no immediate repeat |

A **second, string-keyed parallel table** for the same 6 people exists in `scr_dialogue_functions.gml`, keyed by NITW-style `npc_id`/`speaker` strings (`"guramahsh"`, `"scary"`, `"poet"`, `"frank"`, `"dryellow"`, `"cloud"`) rather than the `CUSTOMER` enum — not synchronized with it by the compiler, so a typo would silently fall through to `default`:
- `dialogue_get_speaker_name(speaker_id)` — display name (also handles orphaned NITW template names `"mae"`/`"bruce"`/`"npc_02"`(Gregg)/`"npc_03"`(Angus), none of which appear anywhere in `vesti_dialogue.json` or any placed NPC).
- `dialogue_speaker_name_color(speaker_id)` — **live**, used by the box renderer. Guramahsh=`c_purple`, Scary=`c_maroon`, Poet=`c_teal`, Frank=`c_white`, Dr. Yellow=`c_yellow`, Mrs. Cloud=`c_aqua`. (Some inline comments mismatch the actual constant, e.g. `c_maroon // friendly green` — cosmetic only.)
- `dialogue_speaker_text_color(speaker_id)` — **fully stubbed**: every case returns `c_white`, with the real intended `make_color_rgb(...)` value commented out immediately after each case (lavender/pale-green/pale-blue/off-white/pale-yellow/pale-sky/lime). All customer dialogue body text currently renders plain white.

---

## 3. Core Systems

### 3.1 Assembly line

**Two parallel, fully-built implementations exist. Only one is reachable by the player.**

| | **V1 "grid" (dead — room `AssemblyLine` is never `room_goto`'d to)** | **V2 "surface" (LIVE — room `AssemblyLineV2`)** |
|---|---|---|
| Table/hand | `oAssemblyTable` (does its own painting/stamping in `Step_0`) | `oHand` (global mouse-follow actor; owns all painting/stamping/economy) |
| Pizza | `oPizza` instance, or a parallel plain struct from `Pizza_Create()` | `oPizzaV2` instance |
| Ingredient source | `oCondimentTub` + `oTub_Sauce/Cheese/Pepperoni/Mushroom/Glass` → `Tub_OnClicked` sets `table.active_ingredient` | `oBin` × 6 (configured via room instance-creation code) → inline `on_clicked` sets `global.hand_mode`/`global.active_ingredient` |
| Sauce/cheese storage | 2D boolean grid (`grid_sauce[]`/`grid_cheese[]`), 24×24 cells at `grid_cell=12`px; coverage = filled/inside ratio | Two GPU surfaces (`surf_sauce`/`surf_cheese`, 1500×1500px) painted with rotated brush stamps; coverage tracked as discrete glob counts vs. a target |
| Topping placement | Continuous drag-stamp with 18px min spacing (`Pizza_StampTopping`), stored as structs in a `ds_list`, **absolute world coords — do not follow the pizza if dragged**, no cost | Discrete one-per-click `oTopping` instances parented via `local_x/y` offset (**do** follow the pizza), full money economy |
| Cooking | `oOvenStation`, timer-based — **placed in zero rooms, dead** | `oCookButton`, click-based |
| Box/scoring | none | `oPizzaBox` → `oPizzaDropZone` → `oSliceScore` |

The rest of this section documents the **live V2 system**.

**`oHand`** (`objects\oHand\*.gml`) is the single global mouse-hand controller for `AssemblyLineV2`. Every frame: follows `mouse_x/mouse_y`, handles pickup/drop of any `oInteractable` (spring-follow physics via `vx/vy += (target-x)*drag_strength`, consumed by `oInteractable`'s own Step), and — only while `global.hand_mode == HAND_MODE.PAINT` and overlapping `oPizzaV2` — runs two mutually-exclusive branches:

- **Discrete toppings** (Pepperoni/Mushroom/Glass), one spawn per `mb_left` press, gated by: radius check against `pizza.pizza_radius_surf * image_xscale`; per-type count vs. `max_pepperoni/mushroom/glass` (all 99, effectively uncapped); and `global.money >= scr_topping_cost(ingredient)`. On success: `global.money -= cost`, plays a per-ingredient SFX, spawns an `oTopping` instance (`local_x/y` relative to the pizza, `depth = -500 - global.topping_depth++` so newer toppings always render on top, random `variant`), increments `pizza.topping_counts[ingredient]`, spawns 5–7 `oGlobSplat` particles, and shows a `-$N` `oMoneyPopup`. If under the limit but unaffordable: shows a "Can't afford!" popup (a `sfx_play(snd_sfx_deny, ...)` line exists but is **commented out** — no audio cue for a denied purchase).
- **Sauce/Cheese/SpecialSauce**, continuous while `mb_left` held: every `pizza.glob_rate` (2) frames, if under `sauce_target`/`cheese_target` (400 each on `oPizzaV2` — see discrepancy below), increments the glob counter and calls `PizzaScripts(pizza, x, y, ingredient)`, which stamps a randomly-rotated brush sprite at 5× scale/0.9 alpha onto the matching GPU surface, clipped to a circle of radius `pizza_radius_surf - 60` (60px brush-half-size buffer). Manages a **looping** paint SFX (`snd_sfx_sauce`/`snd_sfx_cheese`) started/stopped based on whether painting is happening that frame, stopped for real on room-end (`oHand\Other_5.gml`). Sauce and cheese are always free (`scr_topping_cost` returns 0). Using `SPECIALSAUCE` sets `global.special_sauce_used = true` — a scoring bypass consumed once by `Pizza_CalcSlice` (see §3.2).

**Topping economy (exact prices):** Pepperoni **$1**, Mushroom **$2**, Glass Shard **$5**. Sauce/Cheese/Special Sauce are always **$0**. This is the only place in the codebase where `global.money` is decremented.

**Camera zoom/pan** — `oCamera` (`objects\oCamera\*.gml`), only placed in `AssemblyLineV2`:
```gml
// Step_0 — mouse-wheel zoom toward cursor, middle-mouse pan
zoom = clamp(zoom + wheel * zoom_step, zmin, zmax);   // zmin=1, zmax=4, zoom_step=0.25
// view size floored to whole pixels to avoid sub-pixel cursor wobble
// camx/camy repositioned so the same world point stays under the cursor while zooming
```
`Step_2.gml` (End Step, runs after `oHand`'s Step) applies the final camera position — including `oHand.shake_ox/oy` (see §3.5's screen-shake) — and re-derives `oHand.x/y` from `mouse_x/mouse_y` *after* the camera moves, specifically so the paint brush doesn't visibly trail behind the cursor during shake or zoom. Pan is middle-mouse-drag only, clamped to stay inside room bounds.

**Cook state** — see §2.2 (both drivers documented there). `Pizza_Cook()` propagates `cook_state` to every `oTopping` parented to the pizza.

**Pizza box open/close** — `oPizzaBox` is a string state machine (`box_state: "open" | "closed"`). While `"open"` and not held, it tracks distance to the (singleton) `oPizzaV2`, driving a proximity glow (`glow_intensity`, pulsing spotlight rings) and ambient gold sparkle particles that spawn faster the closer the pizza gets. When the pizza is dragged within `snap_radius` (100px) of the box center: the pizza snaps exactly onto the box, becomes un-pickable/un-clickable, the box flips to `"closed"` (new sprite, screen-shakes 6/12, plays `snd_sfx_pizza_done`, spawns a 20-particle gold burst), snapshots `global.pizza_sauce/cheese/cook/toppings/topping_counts` and sets `global.pizza_ready = true`, and — critically — **becomes pickable itself** so the player can carry the closed box away. Nothing in `oPizzaBox` ever sets `box_state` back to `"open"`; "reopening" only happens because `CounterPizzaDelivery`'s room-creation code spawns a brand-new box instance already `"closed"` (the cross-room snapshot pattern from §1.3).

**Known discrepancy:** `oPizzaV2.sauce_target`/`cheese_target` = **400**, but the live scorer (`Pizza_CalcSlice`) divides sauce/cheese glob counts by **300** (matching `Pizza_Constants.gml`'s `SAUCE_FULL`/`CHEESE_FULL` macros, not `oPizzaV2`'s own target). The top ~25% of what the paint-cap logic allows the player to paint is invisible to scoring — coverage silently clamps at 100% past 300 globs with no in-game feedback.

### 3.2 Order system

**Order generation** — `scr_order_new()` (`scr_customer_functions.gml`): returns an `array_create(INGREDIENT.COUNT, 0)` array indexed directly by the `INGREDIENT` enum. Sauce and cheese are each independently included 75% of the time (`random(1) < 0.75`). Then `irandom_range(1, 3)` distinct topping types are drawn without replacement from `scr_orderable_ingredients()` (Pepperoni/Mushroom/Glass); each gets a quantity of `irandom_range(10,15)` (15% chance, "large order") or `irandom_range(5,8)` (85% chance). A guarantee clause force-sets sauce=1 if the roll produced a completely empty order.

**The two-axis grade** — `Pizza_CalcSlice(sauce_globs, cheese_globs, cook_state, topping_count, topping_counts, order)` in `scripts\Pizza_CalcSlice\Pizza_CalcSlice.gml` is the **only live scorer** (called from `oPizzaDropZone\Step_0.gml`). Two independent axes:

- **Axis 1 — SLICE craft quality (`_score`, 0-100), purely physical, ignores the order entirely:**
  ```gml
  var _score = 100;
  // sauce: ideal 0.7 of 300-glob "full" scale, ±0.12 tolerance before penalty (up to -40)
  // cheese: ideal 0.75 of 300-glob scale, ±0.12 tolerance (up to -40)
  if cook_state == PIZZA_COOK.BURNT    _score -= 35;
  if cook_state == PIZZA_COOK.UNCOOKED _score -= 20;
  if topping_count == 0  _score -= 15;
  if topping_count > 15  _score -= 10;
  _score = clamp(_score, 0, 100);
  var _base_scoops = floor(_score / 10);         // 0-10
  var _base_money  = 5 + floor(_score * 0.5);    // $5-$55
  ```
- **Axis 2 — order-match satisfaction (`_satisfaction`, 0-100 or -1 if no order):** for each requirement actually ordered (sauce/cheese/each orderable topping type), accumulates a 0-1 match ratio; unwanted sauce/cheese present when not ordered subtracts 0.5, a wrong topping type present subtracts 0.4 (so `_met` can go negative before the final clamp). `_satisfaction = clamp(_met/_req*100, 0, 100)`, contributing another `floor(sat/10)` scoops and `floor(sat*0.3)` dollars.

**Rank + bump:**
```gml
var _ranks = ["F-","F","F+","D-","D","D+","C","B","A","S","S+"];
// _ri derived purely from _score (11 tiers, thresholds every 10 points from >=10 to >=97)
var _bump = 0;
if (_satisfaction >= 0) {
    if      (_satisfaction >= 100) _bump =  2;   // exact order  → +2 tiers
    else if (_satisfaction >=  80) _bump =  1;   // close        → +1 tier
    else if (_satisfaction <   40) _bump = -1;   // wrong pizza  → -1 tier
}
_ri = clamp(_ri + _bump, 0, array_length(_ranks) - 1);
```
This is the literal "rank bump" mechanic: base rank comes from craft quality alone, then satisfaction nudges it ±1-2 tiers.

**Excellence bonuses** (stack on top): `_great_order (sat≥95) && score≥97 → +50 scoops/+$75 "PERFECT PIE!"`; `great_order && great_quality (score≥80) → +30/+$50 "MASTERPIECE!"`; `great_order alone → +20/+$30 "PERFECT ORDER!"`; `great_quality alone → +15/+$20 "GORGEOUS PIZZA!"`.

**Special-sauce premium:** `if (global.special_sauce_used) { scoops+=100; money+=50; global.special_sauce_used=false; }` — a flat bonus that bypasses both axes entirely.

**"Talk-or-freestyle"** is real but narrower than it might sound: `global.order_revealed` only gates whether the HUD order-ticket shows real requirements vs. a `"???"` placeholder ("Talk to the customer for their order!"). **Nothing gates the actual grading on it** — `oPizzaDropZone` always passes `global.current_order` to `Pizza_CalcSlice`, whether or not the player ever talked to the customer. So "talk" = play informed; "freestyle" = guess blind; both are scored identically. The one dialogue choice in the game (Guramahsh's "good"/"bad" pizza description) only branches to flavor-text response nodes — it never touches `global.current_order`.

**Known bug:** `scr_customer_satisfaction_lines()` (flavor-text ladder for the score screen) has no branch below 10, so a satisfaction score under 10 falls through to the friendliest default line (`"has no opinions."`) instead of the harshest one — almost certainly a missing-branch bug.

**Dead code:** `Pizza_FinalizeScore()` (`scripts\Pizza_FinalizeScore\Pizza_FinalizeScore.gml`) is a complete, independent, older scoring function (70/30 accuracy/speed weighting, `F/C/B/A/S/S+` 6-tier rank table, 15-second speed grace period) with **zero callers anywhere in the project** — fully superseded by `Pizza_CalcSlice`.

### 3.3 Customer system

**Rotation:** despite `global.customer_queue = ["counter_customer", "counter_customer_2"]` suggesting a FIFO queue, there is **no actual queue** — only one customer is ever active. `scr_customer_new()` (`scr_customer_functions.gml`) picks a uniform-random `CUSTOMER` enum value that's guaranteed not to repeat the previous one (`do...until (_next != _prev)`), and writes `global.current_customer`, re-derives `global.current_customer_sprite`, rolls a fresh `global.current_order`, and resets `order_served`/`order_revealed`. `"counter_customer_2"` is never instantiated in any room. A block in `oCustomerDelivery\Step_0.gml` that increments/wraps `global.current_customer` against `array_length(global.customer_queue)` runs immediately before `scr_customer_new()` unconditionally overwrites it — that increment is dead code with zero runtime effect.

**Per-customer dialogue:** `oNPC\Step_0.gml` picks the dialogue node for the one placed `npc_id == "counter_customer"` instance based on `global.order_revealed`: `scr_customer_greet_node(current_customer)` (false) or `scr_customer_wait_node(current_customer)` (true). Both resolve to string node ids (`"greet_guramahsh"`, `"wait_poet"`, etc.) looked up by linear scan against `obj_dialogue_manager.dialogue_data.nodes`. `global.order_revealed` flips to `true` only when a full dialogue interaction with the counter customer completes.

**Name colors:** `dialogue_speaker_name_color()` — see §2.4. Live and used by the box renderer's name-tag color. Body-text color per customer exists as designed RGB values but is currently stubbed to plain white (§2.4).

**Generic NPC template:** `oNPC\Create_0.gml`/`Step_0.gml` also support a generic `npc_id`/`met_<id>`/`<id>_greet`/`<id>_greet_return` pattern for non-counter NPCs with a `press`-type trigger — but no such NPC is placed in any room (the only live `oNPC` instance is the counter customer, auto-triggered), so this branch is currently unreachable.

### 3.4 Money / economy / SCOOPS / reputation

**Money — sources and sinks:**
- **Earn:** coin-banking in `CounterMoney` (`oMoneyCounter\Create_0.gml`'s `bank_coin()`, `global.money += coin_value`) and pizza-delivery rewards (`oSliceScore\Step_0.gml`, `global.money += money_earned`).
- **Spend:** only one site — `oHand\Step_0.gml`'s topping-purchase gate (`global.money -= cost`). Money can never go negative (the `>= cost` guard is the only check).
- Coin values: `oPenny` = **$1**, `oQuarter` = **$25**, `oKey` = **$100**. Note `oKey` uses the literal key sprite (`spr_key`) but behaves exactly like a $100 coin — no lock/unlock mechanic reads a "key" concept anywhere; almost certainly a re-skinned/repurposed asset, not an actual key item.
- `oMoneyCounter` (in `CounterMoney`) auto-banks any nearby unheld `oInteractable` with a `coin_value` field within a 150px radius — no drag-and-release confirmation required, it just has to drift into range.

**SCOOPS / reputation:**
- `global.scoops`, capped at **800**, incremented only in `oSliceScore\Step_0.gml` (`global.scoops = min(global.scoops + scoops_earned, 800)`).
- A "tier" is `floor(scoops/100)` — 8 tiers (0-7) across the 0-800 range. Crossing a tier triggers a one-time celebration: stronger screen shake (15/25 — the strongest in the game), an 80-particle confetti burst, `snd_sfx_tier_up`, and a banner pulling `title`/`rank` strings from `oHUD.scoops_titles`/`scoops_ranks`.
- **SCOOPS has zero mechanical consequence.** Confirmed via exhaustive grep of `global.scoops` (8 total references project-wide): it drives the HUD's colored rank bar/title and the tier-up celebration, and nothing else — no unlocked recipes, no gated content, no price changes, no different dialogue.
- **Important:** the HUD's 8-tier SCOOPS-reputation scale (`scoops_titles`/`scoops_ranks`, e.g. `"C  Technically a Pizzeria"`) and `Pizza_CalcSlice`'s 11-tier per-pizza craft/order rank (`_ranks = ["F-","F","F+",...]`) are **two separate scales that happen to share letter names** — don't conflate `global.last_rank` (per-pizza) with the SCOOPS tier rank shown elsewhere on the HUD.

### 3.5 Dialogue engine (ported NITW-style system)

Confirmed to be a direct port of a Night in the Woods–style dialogue system: `dialogue_get_speaker_name()` still contains orphaned branches for `"mae"→Mae`, `"bruce"→Bruce`, `"npc_02"→Gregg`, `"npc_03"→Angus` (none of these ever appear in `vesti_dialogue.json` or any placed NPC), and `dialogue_start()` still comments `// "Lock Mae"` when it zeroes `obj_player.hsp/vsp`.

**Data source:** `datafiles\vesti_dialogue.json`, loaded once in `obj_dialogue_manager\Create_0.gml` via `buffer_load` → `buffer_read(buffer_text)` → `json_parse` → stored whole as `dialogue_data = { nodes: [...] }`. If the load fails, the failure is silently swallowed (`// DO NOTHING`) and every subsequent `dialogue_start()` call fails to find its node.

**Schema:** each node has `{ id, renderer?, box_layout?, box_style?, title?, lines: [...] }`. Each line is either a normal line `{ speaker, text, portrait? }` (text supports inline markup — see parser below) or a choice line `{ type:"choice", style, title, options:[{text, goto}] }`. 13 nodes total: `greet_<name>`/`wait_<name>` for each of the 6 customers, plus `guramahsh_good`/`guramahsh_bad` (the only branching customer — the choice only changes flavor-text, never the order). Node lookup is a linear string-id scan, O(n), no id→index map.

**Parser** — `dialogue_parse_text(text)` (`scripts\scr_dialogue_parser\scr_dialogue_parser.gml`): single-pass bracket-tag scanner supporting `[i]`/`[/i]` italic, `[wave]`/`[shake]` per-character effects, `[br]` forced newline, `[color=NAME]`/`[color=#RRGGBB]`/`[/color]` (named palette: red/green/blue/yellow/white/black/orange/purple/gray/lime/aqua/pink, unrecognized names silently degrade to white). Output is an array of per-character structs `{char, italic, effect, color, x_off, y_off, alpha, revealed}`. **None of this rich-text markup is actually used anywhere in `vesti_dialogue.json`** — fully functional but currently undemonstrated by any content.

**Typewriter / advance** — `obj_dialogue_manager\Step_0.gml`: reveals 2 characters/frame (`typewriter_speed=2`, frame-rate-tied, not delta-time), plays `snd_typewriter` per non-whitespace/punctuation character with ±10% random pitch. Advance input is `E` (`interact_key`) or left-click: if the line isn't fully revealed, the press instantly reveals the rest (skip); if it is, the press calls `dialogue_next_line()`. Choices navigate with arrow keys/WASD (vertical/horizontal/horizontal_extended styles), confirmed with the same advance input, which calls `dialogue_start(chosen.goto)` — restarting the whole node pipeline rather than just advancing a line index.

**Renderers:** `obj_dialogue_box` (screen-anchored GUI box, used by the counter customer — every node in the JSON sets `box_style: "undertale"`, which renders a solid-white-outer/black-inset box, no sprite) and `obj_dialogue_bubble` (world-anchored speech bubble above the speaker, dynamically sized to the revealed text, hardcoded white-bubble/black-text regardless of speaker). The box's slide-in animation exists in code but **never actually plays** (`slide_progress` starts at `1`, i.e. already fully in place, on every new instance).

**Flags:** `obj_dialogue_manager.flags` is a generic struct key/value store (`dialogue_set_flag`/`dialogue_get_flag`); the only flag ever set is `met_<npc_id>`. Not persisted — resets every game launch.

### 3.6 HUD

`objects\oHUD\*.gml` — persistent, singleton, always-Draw-GUI. Hidden in `hidden_rooms = [MainMenu, Computer]`. Layout: player name + money (row 1); an animated SCOOPS progress bar (`_tier = floor(scoops/100)`, fills 0→1 within the current 100-pt band using a smoothed `display_scoops`); a context-dependent label above the bar (in `AssemblyLineV2`: selected-topping name/color, or "ALL DONE!", or a random idle prompt; elsewhere: the SCOOPS tier rank+title); raw SCOOPS count + "Last Pizza: <rank>"; a pulsing gold objective line from `hud_get_objective()` (`scripts\HudGetObjective\HudGetObjective.gml`, pure room+`pizza_ready` string lookup, no side effects); and, only in `AssemblyLineV2`/`CounterCustomer`, a drawn order-ticket receipt (placeholder "???" until `order_revealed`, then live done/todo/bad rows per ingredient).

The player-facing "hide HUD" feature is the `H` key, which toggles a local `hud_shown`/`hud_offset` slide animation — **unrelated to** `global.hud_visible`, which is initialized `true` and never set false anywhere (an inert leftover flag, only read as an early-exit guard).

### 3.7 Audio / jukebox

`oJukebox` (persistent singleton) owns one music channel. `scripts\JukeboxScripts\JukeboxScripts.gml`:
- `jukebox_play(track)` — idempotent (no-op if already playing that track); otherwise hard-stops the current track and starts the new one **looping** at full gain, canceling any active duck.
- `jukebox_stop()` and `jukebox_duck(target_vol, speed)` — both fully implemented (including the gain-easing consumer in `oJukebox\Step_0.gml`) but have **zero call sites anywhere in the project** — unfinished/unwired features.
- `sfx_play(snd, pitch_vary=true, vol=1)` — the general one-shot SFX helper, ±8% random pitch by default.

Room music is set via each room's `RoomCreationCode.gml` calling `jukebox_play` (`MainMenu`→title, `VestiOffice`→office, `Computer`→computer, `VestiPalace`→overworld, `AssemblyLineV2`→assembly). **`CounterMoney`, `CounterCustomer`, and `CounterPizzaDelivery` have no such call** — they implicitly rely on whatever music was already playing (per a comment in `VestiPalace`'s creation code, the assumption is the player always transits through `VestiPalace` first). Gameplay events also hijack the single music channel directly: `snd_sfx_drumroll` (delivery detected, played via `jukebox_play` even though it's a one-shot SFX — it loops until overridden), and `oSliceScore`'s rank-tier'd stinger (`snd_music_victory`/`snd_sfx_cheer_small`/`snd_sfx_groan`) and `snd_sfx_tier_up`.

### 3.8 Juice / particles / screen shake

`screen_shake(intensity, duration)` (`scripts\ScreenShake\ScreenShake.gml`) sets `shake_intensity/duration/timer` on the singleton `oHand` — **a no-op if `oHand` doesn't exist in the current room** (e.g. calls from `oSliceScore`/`oPizzaBox` in `CounterPizzaDelivery`, which has no `oHand`, silently do nothing there). `oHand\Step_0.gml` computes a linearly-decaying random per-axis offset (`shake_ox/oy`) each frame; `oCamera\Step_2.gml` is the primary consumer (adds it to the camera position in `AssemblyLineV2`); `oHand` also applies it directly to the camera as a fallback only if `oCamera` doesn't exist. Six call sites, intensity/duration pairs: coin banked (4/8), cook button clicked (8/15), pizza box closed (6/12), score-reveal moment (12/20), SCOOPS tier-up (15/25, the strongest).

`oGlobSplat` is the general-purpose particle: a shrinking/fading filled circle (`size * alpha`, both driven by remaining life fraction), gravity-integrated. Reused for: topping-placement splats (5-7 particles, ingredient-tinted), sauce/cheese paint spray (4/tick), pizza-box proximity sparkles (gold, negative gravity so they float up), box-close burst (20, gold), and `oSliceScore`'s confetti (80 on tier-up, 30 "earnings burst" every delivery — these are plain structs, not instances, simulated inline in `oSliceScore\Step_0.gml`). `oGlob` is a separate, simpler fading-sprite object used only as the visible "dab" left by each sauce/cheese paint tick (cosmetic — the actual persistent paint lives on the GPU surfaces).

### 3.9 Save/load

**None exists.** No file/buffer/ini/json persistence of game state was found anywhere in the project (the one JSON read, `vesti_dialogue.json`, is static content, not save data). All progress — money, SCOOPS, pizzas made, dialogue-met flags — lives only in RAM for the process lifetime and resets completely on relaunch.

---

## 4. Key Variables & Globals Reference

Every `global.*` referenced anywhere in the codebase (grep-verified exhaustive), with where it's authoritatively initialized and who else must not break it:

| Global | Initialized | Purpose / who depends on it |
|---|---|---|
| `global.game_mode` | `iGame\Create_0` (`"UI"`) | `"RPG"` in VestiPalace/VestiOffice else `"UI"`, driven every step by `iGame\Step_0`. Gates player visibility/movement. |
| `global.hand_mode` | `iGame\Create_0` (`HAND_MODE.GRAB`) | `oHand`, `oBin`, `oPizzaV2`, `oPizzaBox`, `oAssemblyTable` (legacy) — GRAB vs PAINT mode |
| `global.player_can_move` | `iGame\Create_0` (`true`) | `obj_player\Step_0` movement gate |
| `global.return_room` | `iGame\Create_0` (`VestiOffice`, once) | Set by `iGame\Step_0` on RPG→UI transitions; read by `oUIRoomController` for Esc/C |
| `global.counter_min/max_x/y` | `iGame\Create_0` | Rectangle used by `drag_bounds_mode == 1` (`oInteractable`, `oHand`) |
| `global.active_ingredient` | `iGame\Create_0` (`INGREDIENT.NONE`) | Currently-selected paint ingredient; read throughout `oHand`, `oHUD` |
| `global.topping_depth` | `iGame\Create_0` (0) | Draw-order counter for placed toppings; reset on `oPizzaV2` room-end |
| `global.customer_queue` | `iGame\Create_0` | **Vestigial** — see §3.3, no real queue exists |
| `global.current_customer` | `iGame\Create_0`, then `scr_customer_new()` | `CUSTOMER` enum id of the active customer |
| `global.current_customer_sprite` | `iGame\Create_0`, then `scr_customer_new()` | Sprite asset for the active customer |
| `global.current_order` | `iGame\Create_0`, then `scr_order_new()` | `INGREDIENT.COUNT`-length array, the active order; read by HUD ticket + `Pizza_CalcSlice` |
| `global.order_revealed` | `iGame\Create_0` (false) | Gates HUD ticket visibility (not scoring — see §3.2) |
| `global.order_served` | `iGame\Create_0` (false) | Set false on new customer; not observed to gate anything downstream besides being reset |
| `global.pizza_ready` | `iGame\Create_0` (false) | Set true when box closes; drives HUD objective text + `CounterPizzaDelivery` box respawn |
| `global.pizza_sauce/cheese/cook/toppings` | `iGame\Create_0` (0) | Snapshot of the boxed pizza's stats, written by `oPizzaBox`, read by `Pizza_CalcSlice` |
| `global.pizza_topping_counts` | **not initialized in iGame** — first write is `oPizzaBox\Step_0` | Per-`INGREDIENT` count array snapshot, feeds `Pizza_CalcSlice`'s satisfaction axis |
| `global.special_sauce_used` | **`oBin\Create_0`**, not `iGame` | One-shot flat scoring bonus flag, consumed+reset by `Pizza_CalcSlice` |
| `global.money` | `iGame\Create_0` (0) | Only decremented in `oHand\Step_0` (topping purchase); incremented by coin-banking + `oSliceScore` |
| `global.scoops` | `iGame\Create_0` (0) | Capped 800 in `oSliceScore`; cosmetic only (§3.4) |
| `global.last_slice_score` / `global.last_rank` | `iGame\Create_0` (0 / "-") | Written by `oSliceScore` after each delivery; displayed on HUD |
| `global.pizzas_made` | `iGame\Create_0` (0) | Incremented by `oSliceScore`; **never read anywhere** |
| `global.player_name` | `iGame\Create_0` (`"Myles"`, hardcoded) | Displayed on HUD; no name-entry UI exists |
| `global.hud_visible` | `iGame\Create_0` (true) | Inert — see §3.6 |

---

## 5. Extension Points

**Add a new topping/ingredient:**
1. Add a value to `enum INGREDIENT` in `Pizza_Constants.gml` (before `COUNT`).
2. Add cases to `scr_topping_name`, `scr_topping_icon`, `scr_topping_color`, `scr_topping_cost` in `ToppingScripts.gml`.
3. If it should be orderable, add it to the `scr_orderable_ingredients()` array (`scr_customer_functions.gml` — the comment there literally says "Add additional ones here later").
4. If it's a discrete topping (like Pepperoni/Mushroom/Glass): add a `max_<name>` field to `oPizzaV2\Create_0.gml`, a case to `oHand\Step_0.gml`'s limit switch and SFX switch, and a sprite-selection case to `oTopping\Draw_0.gml`.
5. If it's a base-layer paint (like Sauce/Cheese): add a branch to `PizzaScripts()`'s surface-routing `if` chain and to `oHand\Step_0.gml`'s paint block.
6. Place a new `oBin` instance in `AssemblyLineV2` with matching room instance-creation code (`ingredient_type = INGREDIENT.<NEW>; sprite_index = spr_condiment_<new>;`).
7. Create matching sprite assets (`spr_condiment_<new>`, `spr_<new>_brush`, and cook-state variants if it's a discrete topping).

**Add a new customer:**
1. Add a value to `enum CUSTOMER` in `Pizza_Constants.gml` (before `COUNT`).
2. Add a sprite asset and a case to `scr_customer_sprite()`.
3. Add cases to `scr_customer_name()`, `scr_customer_greet_node()`, `scr_customer_wait_node()` (in `scr_customer_functions.gml`/`scr_dialogue_functions.gml`), plus `dialogue_speaker_name_color()`/`dialogue_speaker_text_color()` if you want a distinct name/text color.
4. Add `greet_<shortname>` and `wait_<shortname>` nodes to `datafiles\vesti_dialogue.json`, with `"speaker"` set to the same short-name string used in step 3's string-keyed dialogue tables (this is a second, independent keying scheme from the `CUSTOMER` enum — keep them in sync manually, there's no compiler check).
5. `scr_customer_new()`'s RNG picker (`irandom(CUSTOMER.COUNT-1)`) will automatically include the new customer once `COUNT` increases — no other rotation code needs to change.

**Add a new room:**
1. Create the room in the GameMaker IDE, add it to `RoomOrderNodes` in the `.yyp` at the desired position (order matters for `room_goto_next()`).
2. If it needs music, add a `RoomCreationCode.gml` calling `jukebox_play(snd_music_<x>)`.
3. If it's an RPG room (top-down, player-walkable), add it to the `if(room == VestiOffice || room == VestiPalace)` check in `iGame\Step_0.gml` so `global.game_mode` is set correctly — this list is a hardcoded `||` chain, not data-driven.
4. If the HUD should be hidden there, add it to `oHUD\Create_0.gml`'s `hidden_rooms` array.
5. If it needs warp-based entry/exit to another RPG room, place `obj_warp_block` instances with `target_room`/`target_x`/`target_y`/`target_face` set via instance creation code.
6. Persistent objects (`iGame`, `oHUD`, `oJukebox`, `oUIRoomController`, `obj_dialogue_manager`, `obj_player`) do **not** need to be placed again — they already persist from `Initialization`.

---

## 6. Known Gaps / Tech Debt

**Structural:**
- An entire parallel pizza-assembly implementation (V1: `oAssemblyTable`, `oPizza`, `oCondimentTub`/`oTub_*`, `Pizza_PaintGrid`, `Pizza_StampTopping`, `Pizza_InitGrid`, `Pizza_GridInitForTable`, `Pizza_CoverageFromGrid`, `Pizza_Create`, `Pizza_ClearAndNew`, `Pizza_FinalizeScore`, `Tub_OnClicked`, `PointInPizza`, `oOvenStation`) sits unreachable in the project (room `AssemblyLine` is never `room_goto`'d to). Safe to delete once confirmed unneeded, but currently a significant source of confusion for anyone grepping the codebase (two `Pizza_*` scoring functions, two cook-state drivers, two topping-placement systems).
- `oOvenStation`, `oPizzaCompleted`, `oServeStation`, `oOrderTicketUI` are placed in **zero rooms** and have no live callers — pure dead weight. `oOrderTicketUI` has no `.gml` files at all (empty event list). `obj_dialogue_test` is likewise an empty stub (sprite only, no code) sitting in `Computer`.
- `obj_money_counter` (distinct from the live `oMoneyCounter`) is a one-line orphaned object (`depth = -50`, nothing else) not placed in any room — except `oMoneyCounter\Create_0.gml` still reads its object-level `depth` property in a formula (`depth = obj_money_counter.depth - 1;`), a brittle cross-reference to a dead object.

**Coverage/scoring inconsistencies:**
- `oPizzaV2.sauce_target`/`cheese_target` = 400 but `Pizza_CalcSlice` scores against a 300-glob "full" scale — the last ~25% of paintable coverage is invisible to scoring.
- `Pizza_Constants.gml`'s `SAUCE_IDEAL`/`CHEESE_IDEAL` macros (0.80/0.85) are unused by the live scorer, which hardcodes its own 0.70/0.75 inline — the macros only match the dead `Pizza_FinalizeScore`.
- `Pizza_CalcSlice`'s return struct fields `sat_bonus_scoops`/`sat_bonus_money` are explicitly commented `//NOT USED` by the original author.
- `scr_customer_satisfaction_lines()` has no branch below satisfaction 10, so the worst scores get the *blandest* flavor line instead of the harshest — likely a missing-branch bug.

**SCOOPS / money:**
- SCOOPS (reputation) has zero mechanical consequence anywhere — purely cosmetic (HUD bar/tier banner). If reputation is meant to gate anything (recipes, customers, prices), that's entirely unbuilt.
- `global.special_sauce_used` is initialized in `oBin\Create_0.gml` rather than centrally in `iGame\Create_0.gml` like every other economy global — fragile (depends on at least one `oBin` existing before the flag is ever read).
- `oKey` is a $100 "coin" wearing a key sprite with no actual key/unlock behavior anywhere in the codebase.

**Audio:**
- `jukebox_stop()` and `jukebox_duck()` are fully implemented end-to-end (including the volume-easing consumer in `oJukebox\Step_0.gml`) but have zero call sites — an unfinished duck-during-dialogue/score-reveal feature.
- `snd_sfx_deny` is referenced only in a commented-out line — no audio plays on a denied topping purchase.
- Several one-shot SFX calls (`snd_sfx_grab`, the three `snd_sfx_topping_*`) pass `true` for `sfx_play`'s loop-like pitch-vary argument in a way worth double-checking against `sfx_play`'s actual signature (`sfx_play(snd, pitch_vary=true, vol=1)` — these are actually fine, pitch-vary, not loop; flagged here only because it reads ambiguously at the call site).
- `CounterMoney`, `CounterCustomer`, `CounterPizzaDelivery` have no `RoomCreationCode.gml` music call — they implicitly inherit whatever was last playing, relying on players always transiting through `VestiPalace` first.
- `objects\oHand\Draw_0.gml` recomputes a shake offset and **decrements `shake_timer` a second time** (already decremented once in `Step_0.gml`), and never applies the offset it computes — dead code with a side-effect bug that roughly halves the effective shake duration.

**Dialogue:**
- `dialogue_speaker_text_color()` is fully stubbed to `c_white` in every branch, with the real designed RGB values commented out immediately after each case.
- The dialogue box's slide-in animation exists but never plays (`slide_progress` starts already at `1`).
- `dialogue_get_speaker_name()` still contains orphaned Night in the Woods template branches (`"mae"`, `"bruce"`, `"npc_02"`, `"npc_03"`) and a leftover `show_debug_message(speaker_id)` call firing on every single lookup.
- `obj_dialogue_box` and `obj_dialogue_bubble` duplicate their entire choice-rendering logic (vertical/horizontal/horizontal_extended) almost line-for-line — a reuse opportunity, not a bug.
- `scr_customer_new()` contains a `with(oNPC)` reset block explicitly commented by the author as `"no longer needed... Safe to delete"` but never removed.

**Room flow / UI:**
- Only `oWindowStart` (of the four draggable window icons shared between `MainMenu` and `Computer`) actually does anything when dropped (`room_goto(VestiPalace)`); `oWindowPalace`/`oWindowPizzaKingdom`/`oWindowVesti` are inert decorative drag toys.
- `global.hud_visible` is dead (never set false); the real player-facing HUD-hide toggle (`H` key) uses a separate local slide-animation mechanism on `oHUD` itself.
- `oCookButton.cook_stage` is a per-button counter that never resets between pizzas — a second pizza made in the same room session could start pre-cooked from the button's perspective if it was clicked before.
- No save/load exists at all — every session starts from scratch (§3.9).

---

## Current Status

Vesti Palace Pizza Kingdom is a GameMaker Studio 2 prototype built around a fully working core loop — walk the RPG overworld, take a customer's order via a ported Night-in-the-Woods-style dialogue system, build a pizza in a physics-driven assembly-line room (freeform surface painting for sauce/cheese, discrete purchasable toppings, camera zoom/pan, click-to-cook, a snap-to-close pizza box), deliver it for a two-axis grade (craft quality × order-match satisfaction, with a rank-bump mechanic and celebratory juice), and bank coins for cash in a side minigame — all glued together by a small set of persistent singleton controllers and a flat `global.*` state model with no save/load. The codebase is data-driven at its core (`INGREDIENT`/`CUSTOMER` enums fan out into a dozen-plus parallel lookup tables) but carries visible scar tissue from active iteration: a complete earlier "V1" assembly-line implementation (grid-based painting, struct-based pizzas, a timer-based oven) still lives in the project alongside the live "V2" surface-based system, several placeholder objects (`oServeStation`, `oOrderTicketUI`, `oOvenStation`, `oPizzaCompleted`) were scaffolded and abandoned, SCOOPS/reputation is tracked but has no mechanical teeth yet, and a handful of numeric inconsistencies (300 vs. 400 glob scales, two different rank tables sharing letter names, an unreachable low-satisfaction flavor-text branch) exist between systems that were clearly built at different times. None of this blocks the current playable loop, but a pass to delete the V1 system and wire up (or remove) the stubbed audio-ducking/reputation-gating hooks would meaningfully shrink the surface area for the next contributor.
