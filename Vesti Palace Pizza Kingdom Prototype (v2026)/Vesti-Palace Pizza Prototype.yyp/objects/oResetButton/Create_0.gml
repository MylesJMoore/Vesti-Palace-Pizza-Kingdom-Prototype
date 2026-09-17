// oDoughButton — Create   (parent = oInteractable, give it a sprite for the mask)
event_inherited();
can_be_picked_up = false;
can_be_clicked   = true;
held = false;

on_clicked = function(self_ref) {
    var pizza = instance_find(oPizzaV2, 0);
    if (!instance_exists(pizza)) exit;
    if (PizzaIsSealed(pizza)) exit;   // committed once boxed

    sfx_play(snd_sfx_grab, false, 0.8);      // placeholder SFX
    PizzaReset(pizza);
    screen_shake(6, 12);
};