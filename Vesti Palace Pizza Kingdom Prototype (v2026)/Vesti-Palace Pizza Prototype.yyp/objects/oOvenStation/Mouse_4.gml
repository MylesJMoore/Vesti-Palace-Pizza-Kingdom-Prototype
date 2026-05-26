var table = instance_find(oAssemblyTable, 0);
if (!instance_exists(table)) exit;

if (!has_pizza) {
    // take pizza from table
    has_pizza = true;
    pizza_in = table.pizza;
    cook_start_time = current_time;

    // table gets a new pizza (empty board)
    table.Pizza_ClearAndNew();
}
else {
    // return pizza to table
    table.pizza = pizza_in;
    pizza_in = noone;
    has_pizza = false;
}