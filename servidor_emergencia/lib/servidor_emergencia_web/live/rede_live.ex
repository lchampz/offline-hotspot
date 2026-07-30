defmodule ServidorEmergenciaWeb.RedeLive do
  use ServidorEmergenciaWeb, :live_view

  alias ServidorEmergencia.Network

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Network Status
        <:subtitle>Information about the local Wi-Fi access point.</:subtitle>
      </.header>

      <div :if={@status.modo == :simulated} class="mt-4 rounded-box bg-warning/20 px-4 py-2 text-sm">
        Simulated mode — no Raspberry Pi is connected. This data is generated
        locally so the interface can be tested before the hardware arrives.
      </div>

      <.list>
        <:item title="SSID">{@status.ssid}</:item>
        <:item title="Access point IP">{@status.ip}</:item>
        <:item title="Connected clients">{@status.clientes_conectados}</:item>
        <:item title="Mode">{modo_label(@status.modo)}</:item>
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

  defp modo_label(:simulated), do: "Simulated (dev)"
  defp modo_label(:real), do: "Real (hardware)"
end
