defmodule Pluggy.Pizza do
  defstruct(id: nil, order_id: nil, name: "", options: "", extra_toppings: "", done: 0)

  alias Pluggy.Pizza

  def all do
    Postgrex.query!(DB, "SELECT * FROM pizzas ORDER BY id", [], pool: DBConnection.ConnectionPool).rows |> to_struct_list()
  end

  def recipes() do
    Postgrex.query!(DB, "SELECT * FROM recepies", [], pool: DBConnection.ConnectionPool).rows
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

  defp to_struct_list(rows) do
    for [id, order_id, name, options, extra_toppings, done] <- rows, do: %Pizza{id: id, order_id: order_id, name: name, options: options, extra_toppings: extra_toppings, done: done}
  end
end
