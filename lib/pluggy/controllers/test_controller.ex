defmodule Pluggy.TestController do

    alias Pluggy.Pizza
    alias Pluggy.Order
    

    def new_order do
        input_list = 
        [
            %{name: "Marinara", options: ["Gluten free"], extra_toppings: ["Mozzarella", "Basilika"]},
            %{name: "Marinara", options: ["Family sized"], extra_toppings: []},
            %{name: "Quattro formaggi", options: ["Child sized"], extra_toppings: ["Basilika"]}
        ]

        order_id = Order.max_order_id + 1

        Enum.reduce(input_list, 0, fn pizza_map, pizza_id_in_order ->
            finished_map = 
            if pizza_map.extra_toppings == [] do
                # pizza_map = Map.put(pizza_map, :toppings, ["Tomatsås"])
                pizza_map = Map.put(pizza_map, :toppings, Pizza.get_toppings_from_name(pizza_map.name))
                Map.delete(pizza_map, :extra_toppings)
            else
                pizza_map
                |> convert_to_toppings
                |> match_toppings_with_pizza
                |> craft_final_pizza
            end

            IO.inspect pizza_id_in_order
            IO.inspect finished_map

            id_in_pizzas_table = finished_map |> Pizza.create
            finished_map |> Order.create(order_id, id_in_pizzas_table, pizza_id_in_order)


            pizza_id_in_order = pizza_id_in_order + 1
        end
        )

    end

    defp convert_to_toppings(original_pizza) do
        # order_toppings = original_pizza.extra_toppings ++ ["Tomatsås"]
        order_toppings = original_pizza.extra_toppings ++ Pizza.get_toppings_from_name(original_pizza.name)
        %{toppings: order_toppings, options: original_pizza.options}
    end

    defp match_toppings_with_pizza(ordered_pizza) do 
        recipe_list = Pizza.all

        matching_pizza =
        Enum.filter(recipe_list, &(&1.toppings -- ordered_pizza.toppings == [])) 
        |> recipe_with_most_toppings

        %{ordered_pizza: ordered_pizza, matching_pizza: matching_pizza}
    end

    defp recipe_with_most_toppings(recipe_list) do
        Enum.reduce(recipe_list, %{toppings: []}, fn recipe, acc ->
            if Enum.count(recipe.toppings) > Enum.count(acc.toppings) do
                recipe
            else
                acc
            end
        end
        )
    end

    defp craft_final_pizza(pizzas) do
        final_pizza_extra_toppings = pizzas.ordered_pizza.toppings -- pizzas.matching_pizza.toppings

        final_pizza_name = 
        if final_pizza_extra_toppings == [] do
            pizzas.matching_pizza.name
        else
            Enum.reduce(final_pizza_extra_toppings, "#{pizzas.matching_pizza.name} med ", fn topping, acc ->
                acc <> topping <> ", "
            end)
            |> String.slice(0..-3)
        end

        %{name: final_pizza_name, options: pizzas.ordered_pizza.options, toppings: pizzas.ordered_pizza.toppings}
    end
end