defmodule ServirtiumTest do
  use ExUnit.Case
  use Plug.Test

  # doctest ServirtiumElixir

  @opts Servirtium.init([])

  test "returns hello world" do
    # Create a test connection
    conn = conn(:get, "/hello")

    # Invoke the plug
    conn = Servirtium.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "world"
  end
end
