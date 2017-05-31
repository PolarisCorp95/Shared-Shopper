use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :shared_shopper, SharedShopper.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :shared_shopper, SharedShopper.Repo,
adapter: Ecto.Adapters.Postgres,
username: "SharedUser",
password: "1995",
database: "DatabaseSharedShopper",
hostname: "localhost",

pool: Ecto.Adapters.SQL.Sandbox

config :comeonin, bcrypt_log_rounds: 4
