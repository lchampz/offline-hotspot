defmodule EmergencyServerFirmware.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        # Children for all targets
        # Starts a worker by calling: EmergencyServerFirmware.Worker.start_link(arg)
        # {EmergencyServerFirmware.Worker, arg},
      ] ++ target_children()

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EmergencyServerFirmware.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  if Mix.target() == :host do
    defp target_children() do
      [
        # Also runs on host: you can resolve any domain against
        # localhost:15353 and open the result in a browser, simulating the
        # captive portal end-to-end without any hardware.
        {EmergencyServer.WildcardDns, wildcard_dns_opts()}
      ]
    end
  else
    defp target_children() do
      [
        # On real hardware, answers with the Pi's own static IP (192.168.24.1).
        {EmergencyServer.WildcardDns, wildcard_dns_opts()}
      ]
    end
  end

  defp wildcard_dns_opts do
    Application.get_env(:emergency_server_firmware, :wildcard_dns)
  end
end
