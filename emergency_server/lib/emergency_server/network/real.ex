defmodule EmergencyServer.Network.Real do
  @moduledoc """
  Real implementation, for when the firmware runs on the Raspberry Pi.

  SSID/IP come from VintageNet's static configuration (we don't use DHCP
  on wlan0, so these values are known at build time and don't need to be
  queried through the VintageNet API).

  Connected-client counting is NOT actually implemented yet — that
  requires reading hostapd's control socket (something like
  `iw dev wlan0 station dump`), which can only be validated with the Pi
  in hand. For now it returns 0 instead of faking data we don't have.
  """

  @behaviour EmergencyServer.Network

  @impl EmergencyServer.Network
  def status do
    %{
      ssid: "LOCAL-EMERGENCY-NETWORK",
      ip: "192.168.24.1",
      connected_clients: 0,
      mode: :real
    }
  end
end
