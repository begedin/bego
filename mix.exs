defmodule Bego.MixProject do
  use Mix.Project

  def project do
    [
      app: :bego,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Bego.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:ecto_sql, "~> 3.11.2"},
      {:esbuild, "~> 0.8.1", runtime: Mix.env() == :dev},
      {:floki, ">= 0.36.2", only: :test},
      {:gettext, "~> 0.24.0"},
      {:jason, "~> 1.4.1"},
      {:phoenix_ecto, "~> 4.6.1"},
      {:phoenix_html, "~> 4.1.1"},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:phoenix_live_reload, "~> 1.5.3", only: :dev},
      {:phoenix_live_view, "~> 0.20.14"},
      {:phoenix, "~> 1.7.12"},
      {:plug_cowboy, "~> 2.7.1"},
      {:postgrex, ">= 0.18.0"},
      {:swoosh, "~> 1.16.7"},
      {:tailwind, "~> 0.2.2", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.1.0"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": [
        "esbuild default --minify",
        "tailwind default --minify",
        "phx.digest"
      ]
    ]
  end
end
