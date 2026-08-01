enum PIZZA_COOK {
    UNCOOKED = 0,
    COOKED   = 1,
    BURNT    = 2
}

enum INGREDIENT {
    NONE = 0,
    SAUCE,
    CHEESE,
    PEPPERONI,
    MUSHROOM,
    GLASS,
	SPECIALSAUCE,
	COUNT
}

enum HAND_MODE {
    GRAB = 0,
    PAINT = 1
}

enum CUSTOMER {
    GURAMAHSH,
    SCARY_GUY,
    POET,
    FRANK,
    DR_YELLOW,
    MRS_CLOUD,
    COUNT
}

#macro SAUCE_FULL    300
#macro SAUCE_IDEAL   0.80
#macro CHEESE_FULL   300
#macro CHEESE_IDEAL  0.85

enum CUSTOMER_SPRITES {
    spr_guramahsh,
    spr_scary_guy,
    spr_poet,
    spr_frank,
    spr_dr_yellow_guy,
    spr_mrs_cloud,
    spr_default_npc
}