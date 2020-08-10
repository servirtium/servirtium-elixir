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
    assign(conn, :private, %{servirtium: %{conn: conn}})
  end
end
