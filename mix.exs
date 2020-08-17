defmodule ServirtiumElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :servirtium_elixir,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:reverse_proxy_plug, "~> 1.3.1"}
    ]
  end
end
