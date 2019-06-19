# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :nilm,
  ecto_repos: [Nilm.Repo]

# Configures the endpoint
config :nilm, NilmWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Dv5Zy5F7R1QBNarU8GUD1sim1ffT6p9OOwCHWruF2ilumgUyutEApnBaGaFNjVx4",
  render_errors: [view: NilmWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Nilm.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
