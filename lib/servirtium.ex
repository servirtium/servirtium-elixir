defmodule Plug.Servirtium.Playback do
  import Plug.Conn

  @spec init(Keyword.t()) :: Keyword.t()
  def init(options) do
    if options[:filename] == nil do
      raise ":filename option must be specified and point to a servirtium playback markdown file"
    end

    # TODO check file exists

    options
  end

  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
  def call(conn, options) do
    options[:filename]
    |> File.read!()
    |> Servirtium.Markdown.from_markdown(conn)
  end
end
