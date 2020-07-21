defmodule Chismoso.Worker do
  use GenServer
  alias Chismoso.State

  def child_spec(state) do
    %{
      id: state.name,
      start: {__MODULE__, :start_link, [state]},
      restart: :permanent,
      type: :worker
    }
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: String.to_atom(state.name))
  end

  def init(state) do
    {:ok, state, state.retry_interval}
  end

  def handle_info(
        :timeout,
        state = %State{failure_count: failure_count, alert_count: alert_count}
      ) do
    case :gen_tcp.connect(state.host, state.port, [], state.tcp_connection_timeout) do
      {:ok, _socket} ->
        new_state = %State{state | failure_count: 0}
        new_state.on_connect.(new_state)
        {:noreply, new_state, new_state.retry_interval}

      {:error, _reason} ->
        new_failure_count = failure_count + 1
        new_state = %State{state | failure_count: new_failure_count}
        new_state.on_disconnect.(new_state)

        if new_failure_count < state.retry_limit do
          {:noreply, new_state, new_state.retry_interval}
        else
          new_alert_count = alert_count + 1
          new_state = %State{state | failure_count: 0, alert_count: new_alert_count}
          state.on_failure.(new_state)

          if new_alert_count < state.alert_limit do
            {:noreply, new_state, new_state.retry_interval}
          else
            {:noreply, %State{state | failure_count: 0, alert_count: 0}, new_state.rearm_after}
          end
        end
    end
  end

  def handle_info({:tcp_closed, _socket}, state) do
    {:noreply, state, state.retry_interval_after_closed}
  end
end
