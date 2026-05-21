function Pizza_ClearAndNew() {
    // free toppings list
    if (is_undefined(pizza) == false) {
        if (ds_exists(pizza.toppings, ds_type_list)) ds_list_destroy(pizza.toppings);
    }
    pizza = Pizza_Create();
    Pizza_GridInitForTable(id);
    active_ingredient = INGREDIENT.NONE;
}