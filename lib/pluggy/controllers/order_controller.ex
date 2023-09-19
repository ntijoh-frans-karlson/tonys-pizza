defmodule Pluggy.OrderController do

    alias Pluggy.Pizza
    alias Pluggy.Order

    import Pluggy.Template, only: [render: 2]
    import Plug.Conn, only: [send_resp: 3]

    def orders(conn) do
        send_resp(conn, 200, render("pizzas/orders", orders: Order.all_orders()))
    end


    def create(conn, params) do
        Order.create_order(params)
        redirect(conn, "/pizzas")
    end

    def delete(conn, pizza_id, order_id) do
        pizza_id = String.to_integer(pizza_id)
        order_id = String.to_integer(order_id)
        Order.delete(pizza_id, order_id)
        redirect(conn, "/orders")
    end

    def toggle_done(conn, pizza_id, order_id) do
        pizza_id = String.to_integer(pizza_id)
        order_id = String.to_integer(order_id)
        Order.toggle_done(pizza_id, order_id)
        redirect(conn, "/orders")
    end

    def order_all(conn) do
      Order.order_all()
      redirect(conn, "/receipts")
    end

    defp redirect(conn, url) do
        Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
    end
end
