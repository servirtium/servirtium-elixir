defmodule ServirtiumTest do
  use ExUnit.Case
  use Plug.Test
  import Plug.Conn

  doctest Servirtium

  def hello_world_plug(conn, _) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "world")
  end

  test "returns hello world" do
    conn = conn(:get, "/hello")
    conn = Servirtium.call(conn, plug: &hello_world_plug/2)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "world"
  end

  test "wraps plug and records the interaction with a function plug" do
    conn =
      conn(:get, "/hello?foo=bar")
      |> put_req_header("content-type", "application/json")
      |> Servirtium.call(plug: &hello_world_plug/2)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.assigns.private.servirtium.conn.request_path == "/hello"
    assert conn.assigns.private.servirtium.conn.resp_body == "world"
    assert conn.assigns.private.servirtium.conn.query_params == %{"foo" => "bar"}

    assert conn.assigns.private.servirtium.conn.req_headers == [
             {"content-type", "application/json"}
           ]
  end

  test "records post and response headers" do
    conn =
      conn(:post, "/hello", "post_body")
      |> put_resp_header("x-paul-is-funny", "true")
      |> Servirtium.call(plug: &hello_world_plug/2)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.assigns.private.servirtium.conn.resp_body == "world"

    assert conn.assigns.private.servirtium.conn.resp_headers == [
             {"cache-control", "max-age=0, private, must-revalidate"},
             {"x-paul-is-funny", "true"},
             {"content-type", "text/plain; charset=utf-8"}
           ]
  end
end
