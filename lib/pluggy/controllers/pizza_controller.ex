defmodule Pluggy.PizzaController do
  require IEx
  alias Pluggy.Pizza
  alias Pluggy.Order

  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    send_resp(conn, 200, render("pizzas/index", pizzas: Pizza.all(), basket: Order.user_basket(0)))
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end


end
