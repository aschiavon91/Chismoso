defmodule Chismoso.State do
  alias Chismoso.DefaultCallbacks
  alias __MODULE__

  @default_retry_limit 10
  @default_retry_interval 1000
  @default_alert_limit 5
  @default_rearm_after 600_000
  @default_tcp_connection_timeout 10000

  defstruct [
    :name,
    :host,
    :port,
    :retry_limit,
    :retry_interval,
    :retry_interval_after_closed,
    :rearm_after,
    :alert_limit,
    :alert_channel,
    :tcp_connection_timeout,
    failure_count: 0,
    alert_count: 0,
    on_connect: &DefaultCallbacks.on_connect/1,
    on_disconnect: &DefaultCallbacks.on_disconnect/1,
    on_failure: &DefaultCallbacks.on_failure/1,
    on_closed: &DefaultCallbacks.on_closed/1
  ]

  def new(params) do
    parsed_data = %{
      name: params.name,
      alert_channel: params.alert_channel,
      host: params.host |> String.to_charlist(),
      port: params.port,
      retry_limit: params.retry_limit || @default_retry_limit,
      retry_interval: params.retry_interval || @default_retry_interval,
      rearm_after: params.rearm_after || @default_rearm_after,
      tcp_connection_timeout: params.tcp_connection_timeout || @default_tcp_connection_timeout,
      retry_interval_after_closed: params.retry_interval_after_closed || @default_retry_interval,
      alert_limit: params.alert_limit || @default_alert_limit
    }

    struct(State, parsed_data)
  end
end
