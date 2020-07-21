defmodule Chismoso.DefaultCallbacks do
  require Logger

  alias Chismoso.State
  alias Chismoso.SlackWebhook

  def on_connect(state) do
    Logger.info("tcp connect to #{state.host}:#{state.port}")
  end

  def on_disconnect(state) do
    Logger.info("tcp disconnect from #{state.host}:#{state.port}")
  end

  @spec on_closed(any) :: :ok | {:error, any}
  def on_closed(state) do
    Logger.info("tcp connection closed from #{state.host}:#{state.port}.")
  end

  def on_failure(state) do
    if state.alert_count <= state.alert_limit do
      msg =
        "tcp failure from #{state.host}:#{state.port}. Max retries exceeded. Failure Alert Count: #{
          state.alert_count
        }"

      Logger.error(msg)
      dispatch_alert(state, msg)
    else
      Logger.error("tcp failure from #{state.host}:#{state.port}. Max Alert exceeded.")
      Logger.warn("Will be rearmed after #{state.rearm_after}...")
    end
  end

  defp dispatch_alert(%State{alert_channel: :slack}, msg), do: SlackWebhook.async_send(msg)

  defp dispatch_alert(_, _),
    do: Logger.warn("No alert channel configured, ignoring alert dispach")
end
