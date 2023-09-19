defmodule Pluggy.Router do
  use Plug.Router
  use Plug.Debugger


  alias Pluggy.ReceiptController
  alias Pluggy.FruitController
  alias Pluggy.UserController
  alias Pluggy.PizzaController
  alias Pluggy.OrderController


  plug(Plug.Static, at: "/", from: :pluggy)
  plug(:put_secret_key_base)

  plug(Plug.Session,
    store: :cookie,
    key: "_pluggy_session",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    key_length: 64,
    log: :debug,
    secret_key_base: "-- LONG STRING WITH AT LEAST 64 BYTES -- LONG STRING WITH AT LEAST 64 BYTES --"
  )

  plug(:fetch_session)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)


  get("/receipts", do: ReceiptController.index(conn))

  get("/pizzas", do: PizzaController.index(conn))
  post("/pizzas/new", do: OrderController.create(conn, conn.body_params))

  get("/orders", do: OrderController.orders(conn))
  post("/orders/toggle_pizza_done/:pizza_id/:order_id", do: OrderController.toggle_done(conn, pizza_id, order_id))
  post("/orders/delete_pizza/:pizza_id/:order_id", do: OrderController.delete(conn, pizza_id, order_id))


  match _ do
    send_resp(conn, 404, "oops")
  end

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end
