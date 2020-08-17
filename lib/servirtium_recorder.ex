defmodule Plug.Servirtium.Recorder do
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

    options[:filename]
    |> File.write!(recorded_interaction)

    conn
  end
end
