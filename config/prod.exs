use Mix.Config

config :project_name, ProjectName.Endpoint,
  http: [port: {:system, "PORT"}, compress: true],
  url: [scheme: "http", host: "database-test.cdhi6jty0xqi.us-east-1.rds.amazonaws.com", port: {:system, "PORT"}],
  secret_key_base: "postgres",
  code_reloader: false,
  cache_static_manifest: "priv/static/manifest.json",
  show_sensitive_data_on_connection_error: true,
  server: true

config :project_name, ProjectName.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "postgres",
  username: "postgres",
  password: "postgres",
  hostname: "database-test.cdhi6jty0xqi.us-east-1.rds.amazonaws.com",
  port: 5432,
  pool_size: 20,
  ssl: true,
  show_sensitive_data_on_connection_error: true

config :logger, level: :info