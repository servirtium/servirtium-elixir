defmodule Servirtium.Markdown do
  import Plug.Conn

  @spec to_markdown(Plug.Conn.t()) :: String.t()
  def to_markdown(conn, id \\ 0) do
    {:ok, req_body, _} = read_body(conn)

    path =
      if conn.query_string == "" do
        conn.request_path
      else
        conn.request_path <> "?" <> conn.query_string
      end

    """
    ## Interaction #{id}: #{conn.method} #{path}

    ### Request headers recorded for playback:

    ```
    #{Enum.map_join(conn.req_headers, "\n", fn {k, v} -> "#{k}: #{v}" end)}
    ```

    ### Request body recorded for playback (#{get_req_header(conn, "content-type")}):

    ```
    #{req_body}
    ```

    ### Response headers recorded for playback:

    ```
    #{Enum.map_join(conn.resp_headers, "\n", fn {k, v} -> "#{k}: #{v}" end)}
    ```

    ### Response body recorded for playback (#{conn.status}: #{
      get_resp_header(conn, "content-type")
    }):

    ```
    #{conn.resp_body}
    ```
    """
  end

  @spec from_markdown(String.t(), Plug.Conn.t()) :: Plug.Conn.t()
  def from_markdown(markdown, conn) do
    case parse_markdown(markdown) do
      nil ->
        raise "Invalid markdown"

      data ->
        status = data["status"] |> String.to_integer()
        resp_body = data["resp_body"]
        conn
        # |> Plug.Conn.merge_resp_headers(data["resp_headers"] |> parse_headers())
        |> Plug.Conn.send_resp(status, resp_body)
    end
  end

  @spec parse_markdown(String.t()) :: map()
  def parse_markdown(markdown) do
    ~r"""
    ## Interaction (?<id>\d+): (?<method>[A-Z]+) (?<path>.+)\s*
    ### Request headers recorded for playback:\s*
    ```\s*
    (?<req_headers>.*)\s*
    ```\s*
    ### Request body recorded for playback \((?<req_content_type>.*)\):\s*
    ```\s*
    (?<req_body>.*)\s*
    ```\s*
    ### Response headers recorded for playback:\s*
    ```\s*
    (?<resp_headers>.*)\s*
    ```\s*
    ### Response body recorded for playback \((?<status>\d+): (?<resp_content_type>.+)\):\s*
    ```\s*
    (?<resp_body>.*)\s*
    ```\s*
    """s
    |> Regex.named_captures(markdown)
  end

  def parse_headers(headers) do
    headers
    |> String.split("\n", trim: true)
    |> Enum.map(fn header ->
      header
      |> String.split(": ", trim: true)
      |> List.to_tuple()
    end)
  end
end
