defmodule ServirtiumTest do
  use ExUnit.Case
  use Plug.Test

  doctest Servirtium

  def hello_world_plug(conn, _) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "world")
  end

  test "returns hello world" do
    # Create a test connection
    conn = conn(:get, "/hello")

    # Invoke the plug
    conn = Servirtium.call(conn, plug: &hello_world_plug/2)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "world"
  end

  test "wraps plug and records the interaction with a function plug" do
    # Create a test connection
    conn = conn(:get, "/hello")

    # Invoke the plug
    conn = Servirtium.call(conn, plug: &hello_world_plug/2)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.assigns.private.servirtium.conn.request_path == "/hello"
  end
end
