defmodule Chismoso.ConnectionError do
  defexception [:message]
end

defmodule Chismoso.SupervisorConfigError do
  @missing_config_msg """

      # Missing supervisor configuration in config file.
      # Config Example:
      config :chismoso, Chismoso.Supervisor,
        workers: [
          %{
            name: "test",                        #required
            host: "localhost",                   #required
            port: 8081,                          #required
            alert_channel: :rollbar,             #required
            retry_limit: 10,                     #optional
            retry_interval: 1000,                #optional
            retry_interval_after_closed: 10000,  #optional
            alert_limit: 5                       #optional
          },
        ]
  """

  defexception message: @missing_config_msg
end

defmodule Chismoso.InvalidTargetError do
  @invalid_target_msg "Invalid target!"
  defexception [:target, message: @invalid_target_msg]
end
