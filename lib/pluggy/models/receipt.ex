defmodule Pluggy.Receipt do
#   alias Pluggy.Pizza

#   require Pizza

#   defstruct(order_id: nil, name: "", options: "", extra_toppings: "")

#   def order do
#     Postgrex.query!(DB, "SELECT order_id, name, options, extra_toppings  FROM pizzas", [], pool: DBConnection.ConnectionPool).rows |> to_struct_list()
#   end

#   # defp to_struct_list(rows) do
#   #   for [order_id, name, options, extra_toppings] <- rows, do: %Pizza{order_id: order_id, name: name, options: options, extra_toppings: extra_toppings}
#   # end

#   #IO.puts Pizza.create(id, name, options, extra_toppings)


end
