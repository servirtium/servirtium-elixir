defmodule Servirtium do
  import Plug.Conn

  @spec init(any) :: any
  def init(options) do
    # check we have a plug delegate
    options
  end

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, opts) do
    conn = opts[:plug].(conn, opts)

    # record headers and bodies from request/response

    put_private(conn, :servirtium, %{conn: conn |> fetch_query_params()})
  end
end
