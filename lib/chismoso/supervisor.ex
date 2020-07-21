defmodule Chismoso.Supervisor do
  @moduledoc false

  use Supervisor

  alias Chismoso.{
    Worker,
    State,
    SupervisorConfigError
  }

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children =
      get_configs()
      |> parse_configs()

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp get_configs() do
    opts = Application.get_env(:chismoso, __MODULE__)
    if Enum.empty?(opts), do: raise(SupervisorConfigError)
    opts[:workers]
  end

  defp parse_configs(cfgs, acc \\ [])

  defp parse_configs([head | tail], acc) do
    parse_configs(
      tail,
      acc ++ [{Worker, State.new(head)}]
    )
  end

  defp parse_configs([], acc), do: acc
end
