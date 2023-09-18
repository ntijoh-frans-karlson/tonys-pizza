defmodule Pluggy.PizzaController do
  require IEx
  alias Pluggy.Pizza

  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    send_resp(conn, 200, render("pizzas/index", pizzas: Pizza.all()))
  end

  def orders(conn) do
    send_resp(conn, 200, render("pizzas/orders", pizzas: Pizza.orders()))
  end


  def create(conn, params) do
    Pizza.new_order(params)
    redirect(conn, "/pizzas")
  end

  def delete(conn, id) do
    id = String.to_integer(id)
    Pizza.delete(id)
    redirect(conn, "/pizzas")
  end

  def toggle_done(conn, id) do
    id = String.to_integer(id)
    Pizza.toggle_done(id)
    redirect(conn, "/pizzas")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
