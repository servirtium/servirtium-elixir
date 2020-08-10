defmodule Servirtium do
  import Plug.Conn

  @moduledoc """
  Documentation for `ServirtiumElixir`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ServirtiumElixir.hello()
      :world

  """

  def init(options) do
    options
  end

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "world")
  end
end
