depth = obj_money_counter.depth - 1;
drop_radius = 150;
image_xscale = 0.3;
image_yscale = 0.3;
popups = [];

bank_coin = function(_coin) {
    var _val = _coin.coin_value;
    global.money += _val;
    
    array_push(popups, {
        x: _coin.x,
        y: _coin.y,
        life: 60,
        max_life: 60,
        val: _val
    });
    
    sfx_play(snd_sfx_cash, true, 1);
    screen_shake(4, 8);
    
    instance_destroy(_coin);
};