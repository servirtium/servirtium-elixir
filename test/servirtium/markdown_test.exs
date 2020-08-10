defmodule Servirtium.MarkdownTest do
  use ExUnit.Case
  use Plug.Test
  import Plug.Conn
  import MockPlug
  alias Servitium.Markdown

  test "markdown generation" do
    conn =
      conn(:post, "/hello?foo=bar")
      |> put_req_header("content-type", "application/json")
      |> Servirtium.call(plug: &hello_world_plug/2)

    assert Markdown.to_markdown(conn.private.servirtium.conn) ==
             """
             ## Interaction 0: POST /hello?foo=bar

             ### Request headers recorded for playback:

             ```
             content-type: application/json
             ```

             ### Request body recorded for playback (application/json):

             ```

             ```

             ### Response headers recorded for playback:

             ```
             cache-control: max-age=0, private, must-revalidate
             content-type: text/plain; charset=utf-8
             ```

             ### Response body recorded for playback (200: text/plain; charset=utf-8):

             ```
             world
             ```
             """
  end
end
