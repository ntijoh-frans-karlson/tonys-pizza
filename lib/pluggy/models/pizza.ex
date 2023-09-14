defmodule Pluggy.Pizza do
  defstruct(id: nil, name: "", options: "", extra_toppings: "", done: 0)

  alias Pluggy.Pizza

  def all do
    Postgrex.query!(DB, "SELECT * FROM pizzas", [], pool: DBConnection.ConnectionPool).rows |> to_struct_list()
  end

  def create(params) do
    id = params["id"]
    name = params["name"]
    options = params["options"]
    extra_toppings = params["extra_toppings"]

    Postgrex.query!(DB, "INSERT INTO pizzas (id, name, options, extra_toppings) VALUES ($1, $2, $3, $4)", [id, name, options, extra_toppings],
      pool: DBConnection.ConnectionPool
    )
  end

  defp to_struct_list(rows) do
    for [id, name, options, extra_toppings, done] <- rows, do: %Pizza{id: id, name: name, options: options, extra_toppings: extra_toppings, done: done}
  end
end
