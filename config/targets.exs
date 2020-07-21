use Mix.Config

config :chismoso, Chismoso.Supervisor,
  workers: [
    %{
      name: "test",
      host: "localhost",
      port: 80,
      alert_channel: :none,
      retry_limit: 10,
      retry_interval: 3000,
      retry_interval_after_closed: 30000,
      rearm_after: 86400,
      tcp_connection_timeout: 5000,
      alert_limit: 1
    },
    %{
      name: "test2",
      host: "127.0.0.1",
      port: 443,
      alert_channel: :none,
      retry_limit: 10,
      retry_interval: 3000,
      retry_interval_after_closed: 30000,
      rearm_after: 86400,
      tcp_connection_timeout: 5000,
      alert_limit: 1
    }
  ]
