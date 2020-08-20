defmodule Plug.Servirtium.Recorder do
  @moduledoc """
  A plug that can be mounted as a reverse proxy to record the
  proxied HTTP interactions while still communicating with the
  upstream server.

  An incoming HTTP request fetches the real response from the
  upstream server and records the HTTP request and response
  in the given Servirtium markdown file.
  """

  @spec init(Keyword.t()) :: Keyword.t()
  def init(options) do
    if options[:filename] == nil do
      raise ":filename option must be specified to save the recording"
    end

    if options[:base_url] == nil do
      raise ":base_url must be specified to record the real HTTP request/response"
    end

    options
    |> Keyword.merge(upstream: options[:base_url])
    |> ReverseProxyPlug.init()
  end

  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
  def call(conn, options) do
    conn = ReverseProxyPlug.call(conn, options)
    recorded_interaction = Servirtium.Markdown.to_markdown(conn)
    File.write!(options[:filename], recorded_interaction)
    conn
  end
end
