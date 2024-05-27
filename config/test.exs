import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bego, BegoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "bQOc4rTULff6VK5l6jQDeLZYxSFfREewW9Xi/VhyDsg7vxO35BScO40Rp2drdWXe",
  server: false

# In test we don't send emails.
config :bego, Bego.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
