defmodule Pluggy.Order do

    alias Pluggy.Order
    alias Pluggy.Option

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

    def max_order_id do
        Postgrex.query!(DB, "SELECT MAX(order_id) FROM orders", [], pool: DBConnection.ConnectionPool).rows |> hd |> hd 
    end

    def all_orders() do
        Postgrex.query!(DB, "SELECT * FROM orders", [], pool: DBConnection.ConnectionPool).rows
    end

    def delete(id) do
        Postgrex.query!(DB, "DELETE FROM pizzas WHERE id = $1", [id])
    end
    
    def toggle_done(id) do
        if Postgrex.query!(DB, "SELECT done FROM pizzas WHERE id = $1", [id]).rows |> hd |> hd == 1 do
            Postgrex.query!(DB, "UPDATE pizzas SET done = 0 WHERE id = $1", [id])
        else
            Postgrex.query!(DB, "UPDATE pizzas SET done = 1 WHERE id = $1", [id])
        end
    end


end