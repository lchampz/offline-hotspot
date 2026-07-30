defmodule EmergencyServerWeb.NetworkLive do
  use EmergencyServerWeb, :live_view

  alias EmergencyServer.Network

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Network Status
        <:subtitle>Information about the local Wi-Fi access point.</:subtitle>
      </.header>

      <div :if={@status.mode == :simulated} class="mt-4 rounded-box bg-warning/20 px-4 py-2 text-sm">
        Simulated mode — no Raspberry Pi is connected. This data is generated
        locally so the interface can be tested before the hardware arrives.
      </div>

      <.list>
        <:item title="SSID">{@status.ssid}</:item>
        <:item title="Access point IP">{@status.ip}</:item>
        <:item title="Connected clients">{@status.connected_clients}</:item>
        <:item title="Mode">{mode_label(@status.mode)}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(2_000, self(), :atualizar)

    {:ok, assign(socket, :status, Network.status())}
  end

  @impl true
  def handle_info(:atualizar, socket) do
    {:noreply, assign(socket, :status, Network.status())}
  end

  defp mode_label(:simulated), do: "Simulated (dev)"
  defp mode_label(:real), do: "Real (hardware)"
end
