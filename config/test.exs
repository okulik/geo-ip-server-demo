import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :geo_ip_server_demo, GeoIpServerDemoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "/cCp/lYwntJSP8UNhiYJ/2ABXGkZ9ZM/cBtb8HMdIHGtB1OZ0THHWkcR0LzgMYjz",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
