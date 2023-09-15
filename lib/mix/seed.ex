defmodule Mix.Tasks.Seed do
  use Mix.Task

  @shortdoc "Resets & seeds the DB."
  def run(_) do
    Mix.Task.run "app.start"
    drop_tables()
    create_tables()
    seed_data()
    print_data()
  end

  defp drop_tables() do
    IO.puts("Dropping tables")
    Postgrex.query!(DB, "DROP TABLE IF EXISTS fruits", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS users", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS pizzas", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS pecipes", [], pool: DBConnection.ConnectionPool)
  end

  # defp create_tables() do
  #   IO.puts("Creating tables")
  #   Postgrex.query!(DB, "Create TABLE fruits (id SERIAL, name VARCHAR(255) NOT NULL, tastiness INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
  # end

  # defp seed_data() do
  #   IO.puts("Seeding data")
  #   Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Apple", 5], pool: DBConnection.ConnectionPool)
  #   Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Pear", 4], pool: DBConnection.ConnectionPool)
  #   Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Banana", 7], pool: DBConnection.ConnectionPool)
  # end

  # "Create TABLE orders (id SERIAL, name VARCHAR(255) NOT NULL, glutenfri INTEGER NOT NULL, familjepizza INTEGER NOT NULL, extras VARCHAR(255), done INTEGER NOT NULL)
  defp create_tables() do
    IO.puts("Creating tables")
    Postgrex.query!(DB, "Create TABLE pizzas (id SERIAL, order_id INTEGER NOT NULL, name VARCHAR(255) NOT NULL, options VARCHAR(255) NOT NULL, extra_toppings VARCHAR(255) NOT NULL, done INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "CREATE TABLE pecipes (id SERIAL, name VARCHAR(255) NOT NULL, ingridients VARCHAR(255) NOT NULL)", [], pool: DBConnection.ConnectionPool)
  end

  defp seed_data() do
    IO.puts("Seeding data")

    # Orders
    Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [0, "Margherita", "gluten_free family_sized", "mushroom", 1])
    Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [1, "Capricciosa", "extra_cheese", "", 0])
    Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [1, "Marinara", "", "", 0])
    Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [2, "Quattro formaggi", "gluten_free family_sized", "mushroom", 1])
    Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [2, "Quattro formaggi", "gluten_free family_sized", "", 1])
    Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [2, "Quattro Formaggi", "gluten_free family_sized", "", 1])
    Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [3, "Ortolana", "", "", 1])
    Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [4, "Prosciutto e funghi", "", "-mushroom", 1])
    Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [4, "Marinara", "", "-tomato_sauce", 1])
    Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [5, "Diavola", "kids_sized", "", 1])

    # pecipes
    Postgrex.query!(DB, "INSERT INTO pecipes(name, ingridients) VALUES($1, $2)", ["Margherita", "tomato_sauce mozzarella basil"])
    Postgrex.query!(DB, "INSERT INTO pecipes(name, ingridients) VALUES($1, $2)", ["Capricciosa", "tomato_sauce mozzarella ham mushroom artichoke"])
    Postgrex.query!(DB, "INSERT INTO pecipes(name, ingridients) VALUES($1, $2)", ["Marinara", "tomato_sauce"])
    Postgrex.query!(DB, "INSERT INTO pecipes(name, ingridients) VALUES($1, $2)", ["Quattro formaggi", "tomato_sauce parmesan peccorino gorgonsola"])
    Postgrex.query!(DB, "INSERT INTO pecipes(name, ingridients) VALUES($1, $2)", ["Prosciutto e funghi", "tomato_sauce mozzarella ham mushroom"])
    Postgrex.query!(DB, "INSERT INTO pecipes(name, ingridients) VALUES($1, $2)", ["Ortolana", "tomato_sauce mozzarella bell_pepper aubergine zucchini"])
    Postgrex.query!(DB, "INSERT INTO pecipes(name, ingridients) VALUES($1, $2)", ["Quattro stagioni", "tomato_sauce mozzarella ham mushroom artichoke olives"])
    Postgrex.query!(DB, "INSERT INTO pecipes(name, ingridients) VALUES($1, $2)", ["Diavola", "tomato_sauce mozzarella salami bell_pepper chili"])
  end

  defp print_data() do
    IO.puts("Print data")
    Postgrex.query!(DB, "SELECT * FROM pizzas",[], pool: DBConnection.ConnectionPool) |> IO.inspect()
    Postgrex.query!(DB, "SELECT * FROM pecipes",[], pool: DBConnection.ConnectionPool) |> IO.inspect()

  end

end
