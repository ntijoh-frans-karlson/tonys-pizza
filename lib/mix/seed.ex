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
    Postgrex.query!(DB, "DROP TABLE IF EXISTS recipes", [], pool: DBConnection.ConnectionPool)
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
    # Postgrex.query!(DB, "Create TABLE pizzas (id SERIAL, order_id INTEGER NOT NULL, name VARCHAR(255) NOT NULL, options VARCHAR(255) NOT NULL, extra_toppings VARCHAR(255) NOT NULL, done INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
    # Postgrex.query!(DB, "CREATE TABLE recipes (id SERIAL, name VARCHAR(255) NOT NULL, ingredients VARCHAR(255) NOT NULL)", [], pool: DBConnection.ConnectionPool)
    # Postgrex.query!(DB,"CRETE TABLE orders(id SERIAL)")

    Postgrex.query!(DB,"CREATE TABLE pizzas(id SERIAL, name VARCHAR(255))", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB,"CREATE TABLE ingredients(id SERIAL, name VARCHAR(255))", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB,"CREATE TABLE recipes(pizza_id INTEGER, ingredient_id INTEGER)", [], pool: DBConnection.ConnectionPool)
  end

  @margherita 1
  @tomato_sauce 1
  @basilika 2

  defp seed_data() do
    IO.puts("Seeding data")
    Postgrex.query!(DB,"INSERT INTO pizzas(name) VALUES($1)", ["Margherita"])         #1
    Postgrex.query!(DB,"INSERT INTO pizzas(name) VALUES($1)", ["Capricciosa"])        #2
    Postgrex.query!(DB,"INSERT INTO pizzas(name) VALUES($1)", ["Marinara"])           #3
    Postgrex.query!(DB,"INSERT INTO pizzas(name) VALUES($1)", ["Quattro formaggi"])   #4
    Postgrex.query!(DB,"INSERT INTO pizzas(name) VALUES($1)", ["Prosciutto e funghi"])#5
    Postgrex.query!(DB,"INSERT INTO pizzas(name) VALUES($1)", ["Ortolana"])           #6
    Postgrex.query!(DB,"INSERT INTO pizzas(name) VALUES($1)", ["Quattro stagioni"])   #7
    Postgrex.query!(DB,"INSERT INTO pizzas(name) VALUES($1)", ["Diavola"])            #8

    Postgrex.query!(DB,"INSERT INTO ingredients(name) VALUES($1)", ["Tomatsås"])       #1
    Postgrex.query!(DB,"INSERT INTO ingredients(name) VALUES($1)", ["Mozarella"])      #2
    Postgrex.query!(DB,"INSERT INTO ingredients(name) VALUES($1)", ["Basilika"])       #3
    Postgrex.query!(DB,"INSERT INTO ingredients(name) VALUES($1)", ["Skinka"])         #4
    Postgrex.query!(DB,"INSERT INTO ingredients(name) VALUES($1)", ["Svamp"])          #5
    Postgrex.query!(DB,"INSERT INTO ingredients(name) VALUES($1)", ["Kronärtskocka"])  #6
    Postgrex.query!(DB,"INSERT INTO ingredients(name) VALUES($1)", ["Parmesan"])       #7
    Postgrex.query!(DB,"INSERT INTO ingredients(name) VALUES($1)", ["Peccorino"])      #8
    Postgrex.query!(DB,"INSERT INTO ingredients(name) VALUES($1)", ["Gorgonsola"])     #9
    Postgrex.query!(DB,"INSERT INTO ingredients(name) VALUES($1)", ["Paprika"])        #10
    Postgrex.query!(DB,"INSERT INTO ingredients(name) VALUES($1)", ["Aubergine"])      #11
    Postgrex.query!(DB,"INSERT INTO ingredients(name) VALUES($1)", ["Zucchini"])       #12
    Postgrex.query!(DB,"INSERT INTO ingredients(name) VALUES($1)", ["Oliver"])         #13
    Postgrex.query!(DB,"INSERT INTO ingredients(name) VALUES($1)", ["Salami"])         #14
    Postgrex.query!(DB,"INSERT INTO ingredients(name) VALUES($1)", ["Chili"])          #15

    Postgrex.query!(DB, "INSERT INTO recipes(pizza_id, ingredient_id) VALUES($1, $2)", [1, 1])
    Postgrex.query!(DB, "INSERT INTO recipes(pizza_id, ingredient_id) VALUES($1, $2)", [1, 2])
    Postgrex.query!(DB, "INSERT INTO recipes(pizza_id, ingredient_id) VALUES($1, $2)", [1, 3])

    Postgrex.query!(DB, "INSERT INTO recipes(pizza_id, ingredient_id) VALUES($1, $2)", [2, 1])
    Postgrex.query!(DB, "INSERT INTO recipes(pizza_id, ingredient_id) VALUES($1, $2)", [2, 2])
    Postgrex.query!(DB, "INSERT INTO recipes(pizza_id, ingredient_id) VALUES($1, $2)", [2, 4])
    Postgrex.query!(DB, "INSERT INTO recipes(pizza_id, ingredient_id) VALUES($1, $2)", [2, 5])
    Postgrex.query!(DB, "INSERT INTO recipes(pizza_id, ingredient_id) VALUES($1, $2)", [2, 6])

    Postgrex.query!(DB, "INSERT INTO recipes(pizza_id, ingredient_id) VALUES($1, $2)", [3, 1])





    # # Orders
    # Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [0, "Margherita", "gluten_free family_sized", "mushroom", 1])
    # Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [1, "Capricciosa", "extra_cheese", "", 0])
    # Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [1, "Marinara", "", "", 0])
    # Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [2, "Quattro formaggi", "gluten_free family_sized", "mushroom", 1])
    # Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [2, "Quattro formaggi", "gluten_free family_sized", "", 1])
    # Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [2, "Quattro Formaggi", "gluten_free family_sized", "", 1])
    # Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [3, "Ortolana", "", "", 1])
    # Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [4, "Prosciutto e funghi", "", "-mushroom", 1])
    # Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [4, "Marinara", "", "-tomato_sauce", 1])
    # Postgrex.query!(DB, "INSERT INTO pizzas(order_id, name, options, extra_toppings, done) VALUES($1, $2, $3, $4, $5)", [5, "Diavola", "kids_sized", "", 1])

    # # Recipes
    # Postgrex.query!(DB, "INSERT INTO recipes(name, ingredients) VALUES($1, $2)", ["Margherita", "Tomatsås Mozzarella Basilika"])
    # Postgrex.query!(DB, "INSERT INTO recipes(name, ingredients) VALUES($1, $2)", ["Capricciosa", "Tomatsås Mozzarella Skinka Svamp Kronärtskocka"])
    # Postgrex.query!(DB, "INSERT INTO recipes(name, ingredients) VALUES($1, $2)", ["Marinara", "Tomatsås"])
    # Postgrex.query!(DB, "INSERT INTO recipes(name, ingredients) VALUES($1, $2)", ["Quattro formaggi", "Tomatsås Parmesan Peccorino Gorgonsola"])
    # Postgrex.query!(DB, "INSERT INTO recipes(name, ingredients) VALUES($1, $2)", ["Prosciutto e funghi", "Tomatsås Mozzarella Skinka Svamp"])
    # Postgrex.query!(DB, "INSERT INTO recipes(name, ingredients) VALUES($1, $2)", ["Ortolana", "Tomatsås Mozzarella Paprika Aubergine Zucchini"])
    # Postgrex.query!(DB, "INSERT INTO recipes(name, ingredients) VALUES($1, $2)", ["Quattro stagioni", "Tomatsås Mozzarella Skinka Svamp Kronärtskocka Oliver"])
    # Postgrex.query!(DB, "INSERT INTO recipes(name, ingredients) VALUES($1, $2)", ["Diavola", "Tomatsås Mozzarella Salami Paprika Chili"])
  end

  defp print_data() do
    IO.puts("Print data")
    Postgrex.query!(DB, "SELECT * FROM pizzas",[], pool: DBConnection.ConnectionPool) |> IO.inspect()
    Postgrex.query!(DB, "SELECT * FROM recipes",[], pool: DBConnection.ConnectionPool) |> IO.inspect()

  end

end
