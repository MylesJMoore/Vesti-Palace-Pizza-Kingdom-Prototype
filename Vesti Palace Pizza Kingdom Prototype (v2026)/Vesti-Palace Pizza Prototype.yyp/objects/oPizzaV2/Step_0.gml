event_inherited();

// Lock pizza in place while in paint mode
if (global.hand_mode == HAND_MODE.PAINT) {
    vx = 0;
    vy = 0;
}