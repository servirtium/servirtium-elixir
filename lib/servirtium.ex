defmodule Servirtium do
  import Plug.Conn

  @moduledoc """
  Documentation for `Servirtium`.
  """

  @spec init(any) :: any
  def init(options) do
    # check we have a plug delegate
    options
  end

  @doc """

  """
  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, opts) do
    conn = opts[:plug].(conn, opts)

    # record headers and bodies from request/response

    put_private(conn, :servirtium, %{conn: conn |> fetch_query_params()})
  end

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
end
