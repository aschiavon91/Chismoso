use Mix.Config

config :logger,
  backends: [:console],
  utc_log: true

config :logger, :console, format: "$time $metadata[$level] $message\n"

config :slack_webhook,
  url: System.get_env("SLACK_HOOK_URL")

import_config("./targets.exs")
