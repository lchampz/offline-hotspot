defmodule EmergencyServer.Network do
  @moduledoc """
  Single interface for Wi-Fi/AP network status. Whoever consumes it (the
  status LiveView, for example) doesn't know whether it's talking to the
  simulator (running on a Mac, no hardware) or the real implementation
  (on the Raspberry Pi).

  This is what lets us code against the interface now — before the
  hardware arrives — and swap only the implementation later, without
  touching the UI.
  """

  @type status :: %{
          ssid: String.t(),
          ip: String.t(),
          connected_clients: non_neg_integer(),
          mode: :simulated | :real
        }

  @callback status() :: status()

  def status, do: impl().status()

  defp impl do
    Application.get_env(:emergency_server, :network_adapter, EmergencyServer.Network.Mock)
  end
end
