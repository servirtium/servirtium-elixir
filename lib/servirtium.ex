defmodule Servirtium do
  import Plug.Conn

  @moduledoc """
  Documentation for `ServirtiumElixir`.
  """

  @spec init(any) :: any
  def init(options) do
    options
  end

    @doc """
  Hello world.

  ## Examples

      iex> ServirtiumElixir.hello()
      :world

  """
  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "world")
  end
end
