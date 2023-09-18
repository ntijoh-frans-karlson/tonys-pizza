defmodule Pluggy.Pizza do
  defstruct(id: nil, name: "", toppings: [])

  alias Pluggy.Pizza

  def get(id) do
    query = """
      SELECT * FROM pizzas
      INNER JOIN recipes
      ON pizzas.id = recipes.pizza_id
      INNER JOIN ingredients
      ON ingredients.id = recipes.ingredient_id
      WHERE pizzas.id = $1
    """
    Postgrex.query!(DB, query, [id], pool: DBConnection.ConnectionPool).rows #|> to_struct_list()
    |> to_struct()
  end

  def all() do
    query = """
      SELECT * FROM pizzas
      INNER JOIN recipes
      ON pizzas.id = recipes.pizza_id
      INNER JOIN ingredients
      ON ingredients.id = recipes.ingredient_id
    """
    Postgrex.query!(DB, query, [], pool: DBConnection.ConnectionPool).rows #|> to_struct_list()
    |> to_struct_list()
  end

  # def all do
  #   Postgrex.query!(DB, "SELECT * FROM pizzas ORDER BY id", [], pool: DBConnection.ConnectionPool).rows |> to_struct_list()
  # end

  def orders() do
    Postgrex.query!(DB, "SELECT * FROM recipes", [], pool: DBConnection.ConnectionPool).rows
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

  defp to_struct(rows) do
    rows
    |> Enum.reduce(%Pizza{}, fn [pizza_id, pizza_name, _, _, _, ingredient_name], acc -> %Pizza{id: pizza_id, name: pizza_name, toppings: [ ingredient_name |acc.toppings]} end )
  end

  defp to_struct_list(rows) do
    rows
    |> Enum.group_by(&List.first/1)
    |> Map.values()
    |> Enum.map(&to_struct/1)
  end


  # defp to_struct_list(rows) do
  #   for [id, order_id, name, options, extra_toppings, done] <- rows, do: %Pizza{id: id, order_id: order_id, name: name, options: options, extra_toppings: extra_toppings, done: done}
  # end
end
