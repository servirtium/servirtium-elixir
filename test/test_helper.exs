ExUnit.start()

defmodule MockPlug do
  def hello_world_plug(conn, _) do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, "world")
  end
end
