defmodule Pluggy.ReceiptController do
  require IEx
  alias Pluggy.Pizza

  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    conn = send_resp(conn, 200, render("pizzas/receipts", receipts: Pizza.all()))
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
