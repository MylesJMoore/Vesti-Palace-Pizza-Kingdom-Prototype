// scripts/DayCycle.gml

function scr_orders_target(_day) {
    // Flat for V4. Scale here in V5 (e.g. return min(ORDERS_PER_DAY + _day - 1, 20);)
    return ORDERS_PER_DAY;
}

function scr_day_start() {
    global.orders_served_today = 0;
    global.day_log             = [];
    global.coins_banked_today  = 0;
    scr_customer_new();   // roll the fresh day's first customer + order
}

function scr_day_record_delivery(_res) {
    _res.order_num = global.orders_served_today + 1;   // 1-based, computed here
    array_push(global.day_log, _res);
    global.orders_served_today++;
}

function scr_day_should_close() {
    return (global.orders_served_today >= scr_orders_target(global.day_number));
}

function scr_day_next() {
    global.day_number++;
    scr_day_start();
}