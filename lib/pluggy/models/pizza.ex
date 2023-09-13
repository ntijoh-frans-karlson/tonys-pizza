defmodule Pluggy.Pizza do
  defstruct(id: nil, name: "", options: "", extra_toppings: "", done: 0)

  alias Pluggy.Pizza

  def all do
    Postgrex.query!(DB, "SELECT * FROM pizzas", [], pool: DBConnection.ConnectionPool).rows |> to_struct_list()
  end

  defp to_struct_list(rows) do
    for [id, name, options, extra_toppings, done] <- rows, do: %Pizza{id: id, name: name, options: options, extra_toppings: extra_toppings, done: done}
  end
end
