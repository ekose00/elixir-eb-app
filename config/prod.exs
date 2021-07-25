use Mix.Config

config :hello, Hello.Endpoint,
  http: [port: {:system, "PORT"}, compress: true],
  url: [scheme: "http", host: "localhost", port: {:system, "PORT"}],
  secret_key_base: "postgres",
  code_reloader: false,
  cache_static_manifest: "priv/static/manifest.json",
  show_sensitive_data_on_connection_error: true,
  server: true

config :hello, HelloWeb.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "postgres",
  username: "postgres",
  password: "postgres",
  hostname: "database-test.cwpfdkzendvi.us-east-1.rds.amazonaws.com",
  port: 5432,
  pool_size: 20,
  ssl: true,
  show_sensitive_data_on_connection_error: true

config :logger, level: :info

import_config "prod.secret.exs"