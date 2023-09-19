defmodule Pluggy.Order do
    defstruct(order_id: nil, pizza_id: nil, name: "", option: "", done: 0)



    alias Pluggy.Order
    alias Pluggy.Option
    alias Pluggy.Pizza

    ###
    def create_order(pizza_map) do

        pizza_map = for {key, val} <- pizza_map, into: %{}, do: {String.to_atom(key), val}
        pizza_map = Map.replace(pizza_map,:extra_toppings, [])
        pizza_map = Map.replace(pizza_map,:options, [])
        pizza_map = Map.replace(pizza_map,:order_id, 0)

        finished_map =
        if pizza_map.extra_toppings == [] do
            pizza_map = Map.put(pizza_map, :toppings, Pizza.get_toppings_from_name(pizza_map.name))
            Map.delete(pizza_map, :extra_toppings)
        else
            pizza_map
            |> convert_to_toppings
            |> match_toppings_with_pizza
            |> craft_final_pizza
        end

        # IO.inspect pizza_id_in_order
        # IO.inspect finished_map

        pizza_id_in_order = Order.new_pizza_id(pizza_map.order_id)

        id_in_pizzas_table = finished_map |> Pizza.create
        finished_map |> Order.create(pizza_map.order_id, id_in_pizzas_table, pizza_id_in_order)


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


    ###


    def create(pizza_map, order_id, id_in_pizzas_table, pizza_id_in_order) do
        if pizza_map.options == [] do
            Postgrex.query!(DB, "INSERT INTO orders(order_id, pizza_id, pizza, options) VALUES ($1, $2, $3, $4)", [order_id, pizza_id_in_order, id_in_pizzas_table, 0], pool: DBConnection.ConnectionPool)
        else
            for option <- pizza_map.options do
                option = Option.name_to_id(option)
                Postgrex.query!(DB, "INSERT INTO orders(order_id, pizza_id, pizza, options) VALUES ($1, $2, $3, $4)", [order_id, pizza_id_in_order, id_in_pizzas_table, option], pool: DBConnection.ConnectionPool)
            end
        end
    end

    def all_ordered_list do

    end

    def new_pizza_id(order_id) do
        max_id = Postgrex.query!(DB, "SELECT MAX(pizza_id) FROM orders WHERE order_id = $1", [order_id], pool: DBConnection.ConnectionPool).rows |> hd |> hd
        max_id + 1
    end

    def max_order_id do
        Postgrex.query!(DB, "SELECT MAX(order_id) FROM orders", [], pool: DBConnection.ConnectionPool).rows |> hd |> hd
    end

    def all_orders() do
        query =
        """
        SELECT orders.order_id, orders.pizza_id, pizzas.name, options.name AS option, done FROM orders
        LEFT JOIN pizzas
        ON orders.pizza = pizzas.id
        LEFT JOIN options
        ON orders.options = options.id
        ORDER BY orders.pizza_id desc
        """

        Postgrex.query!(DB, query, [], pool: DBConnection.ConnectionPool).rows
        |> to_struct
    end

    def delete(pizza_id, order_id) do
        Postgrex.query!(DB, "DELETE FROM orders WHERE pizza_id = $1 AND order_id = $2", [pizza_id, order_id])
    end

    def toggle_done(pizza_id, order_id) do
        if Postgrex.query!(DB, "SELECT done FROM orders WHERE pizza_id = $1 AND order_id = $2", [pizza_id, order_id]).rows |> hd |> hd == 1 do
            Postgrex.query!(DB, "UPDATE orders SET done = 0 WHERE pizza_id = $1 AND order_id = $2", [pizza_id, order_id])
        else
            Postgrex.query!(DB, "UPDATE orders SET done = 1 WHERE pizza_id = $1 AND order_id = $2", [pizza_id, order_id])
        end
    end

    def user_basket(id) do
        Postgrex.query!(DB, "SELECT pizzas.name FROM orders INNER JOIN pizzas ON orders.pizza =  pizzas.id WHERE order_id = $1 AND ordered = $2", [id, 0]).rows |> List.flatten |> IO.inspect
    end

    def order_all() do
      Postgrex.query!(DB, "UPDATE orders SET ordered = 1 WHERE order_id = $1", [0])
    end

    def to_struct(rows) do
        rows
        |> Enum.reduce([], fn [order_id, pizza_id, name, option, done], acc -> [%Order{order_id: order_id, pizza_id: pizza_id, name: name, option: option, done: done} | acc] end )
    end
end
