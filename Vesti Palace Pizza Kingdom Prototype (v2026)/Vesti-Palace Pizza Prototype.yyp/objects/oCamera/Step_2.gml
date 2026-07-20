var _ox = 0, _oy = 0;
if (instance_exists(oHand)) {
    _ox = oHand.shake_ox;
    _oy = oHand.shake_oy;
}

var _fx = floor(camx + _ox);
var _fy = floor(camy + _oy);
camera_set_view_pos(cam, _fx, _fy);

// Re-sync the hand to the cursor AFTER the camera is finalized this frame.
// mouse_x/mouse_y now reflect the just-set camera, so the brush stops trailing.
if (instance_exists(oHand)) {
    oHand.x = floor(mouse_x);
    oHand.y = floor(mouse_y);
}