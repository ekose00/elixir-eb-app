import Config

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
database_url = System.fetch_env!("DATABASE_URL")

config :hello, Hello.Repo,
  # ssl: true,
  url: database_url,
  show_sensitive_data_on_connection_error: true

config :hello, Hello.Endpoint,
  secret_key_base: secret_key_base
