defmodule Plug.Servirtium.Playback do
  @moduledoc """
  A plug that can be mounted to provide playback of pre-recorded
  HTTP interactions.

  An incoming HTTP request has it's response determined by the
  recorded HTTP response in the given Servirtium markdown file.
  """

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
