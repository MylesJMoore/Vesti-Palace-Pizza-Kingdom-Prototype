function hud_get_objective() {
    if room == AssemblyLineV2 {
        if global.pizza_ready return "Take your pizza to the delivery counter!";
        return "Make a pizza, then drop it in the box";
    }
    if room == CounterPizzaDelivery {
        return "Drop the pizza on the customer";
    }
    if room == CounterMoney {
        return "Drop your cash on the counter";
    }
    if room == CounterCustomer {
        return "Take the customer's order";
    }
    if room == VestiOffice {
        return "Take a breather, boss";
    }
    if room == VestiPalace {
        if global.pizza_ready return "Deliver your pizza!";
        return "Head to the Assembly Line to make a pizza";
    }
    return "Make a pizza";
}