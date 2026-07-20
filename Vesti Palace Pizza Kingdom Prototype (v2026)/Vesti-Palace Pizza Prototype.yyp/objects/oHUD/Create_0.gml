if instance_number(oHUD) > 1 {
    instance_destroy();
    exit;
}
instance_persistent = true;

// Rooms where HUD should NOT show
hidden_rooms = [MainMenu, Computer]; // swap to your actual room names

// Assembly Line Idle Prompts
idle_prompt = scr_topping_prompt();

// SCOOPS tier data
scoops_titles = [
    "The Stinkiest Pizza Shop",
    "Bad Mom & Pop Shop",
    "Technically a Pizzeria",
    "Locals Tolerate It",
    "Actually Pretty Good",
    "Sleaze City Favorite",
    "Pizza Royalty",
    "#1 in Sleaze City"
];
scoops_ranks = ["F-", "F", "D", "C", "B", "A", "S", "S+"];
scoops_colors = [
    make_color_rgb(255, 60, 60),   // F- red
    make_color_rgb(255, 60, 60),   // F red
    make_color_rgb(255, 140, 0),   // D orange
    make_color_rgb(200, 200, 200), // C gray
    make_color_rgb(100, 200, 255), // B blue
    make_color_rgb(100, 255, 100), // A green
    make_color_rgb(255, 220, 50),  // S gold
    make_color_rgb(255, 220, 50)   // S+ gold
];

// Animated display value for smooth bar fill
display_scoops = 0;

// HUD Animation Sliding
hud_shown = true;
hud_offset = 0;        // 0 = fully visible, negative = slid up off screen
hud_offset_target = 0;
hud_hidden_offset = -120; // how far up it slides (match your bar height)