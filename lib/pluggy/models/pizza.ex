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
      WHERE pizzas.id < 9
    """
    Postgrex.query!(DB, query, [], pool: DBConnection.ConnectionPool).rows #|> to_struct_list()
    |> to_struct_list()
  end

  def get_toppings_from_name(pizza_name) do
    pizza_map =
    pizza_name
    |> pizza_id_from_name
    |> get

    pizza_map.toppings
  end

  def create(pizza_map) do
    max_id = (Postgrex.query!(DB, "SELECT MAX(id) FROM pizzas", [], pool: DBConnection.ConnectionPool).rows |> hd |> hd)
    new_id = max_id + 1



    name = pizza_map.name
    toppings = pizza_map.toppings

    Postgrex.query!(DB, "INSERT INTO pizzas (id, name) VALUES ($1, $2)", [new_id, name], pool: DBConnection.ConnectionPool)

    for topping <- toppings do
      topping_id = topping_name_to_id(topping)
      Postgrex.query!(DB, "INSERT INTO recipes (pizza_id, ingredient_id) VALUES ($1, $2)", [new_id, topping_id], pool: DBConnection.ConnectionPool)
    end

    new_id
  end

  def topping_name_to_id(name) do
    Postgrex.query!(DB, "SELECT id FROM ingredients WHERE name = $1", [name], pool: DBConnection.ConnectionPool).rows |> hd |> hd
  end

  defp pizza_id_from_name(name) do
    Postgrex.query!(DB, "SELECT id FROM pizzas WHERE name = $1", [name], pool: DBConnection.ConnectionPool).rows |> hd |> hd
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
