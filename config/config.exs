# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :tracking_service_api,
  ecto_repos: [TrackingServiceApi.Repo]

# Configures the endpoint
config :tracking_service_api, TrackingServiceApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "T4nUIoTAkLIZsJiXI/K2tNUcMSmZvJX1eNhxPamRL7pVx9pEjIfOXjrIlfQvIy/a",
  render_errors: [view: TrackingServiceApi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TrackingServiceApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"