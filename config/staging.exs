use Mix.Config

config :bego, BegoWeb.Endpoint,
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  http: [port: {:system, "PORT"}],
  load_from_system_env: true,
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  url: [scheme: "https", host: "bego-staging.herokuapp.com", port: 443]

config :logger, level: :warn

config :bego, buttercms_token: System.get_env("BUTTERCMS_TOKEN")

config :bego, Bego.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true
