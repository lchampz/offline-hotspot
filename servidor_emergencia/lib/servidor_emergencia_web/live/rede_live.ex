defmodule ServidorEmergenciaWeb.RedeLive do
  use ServidorEmergenciaWeb, :live_view

  alias ServidorEmergencia.Network

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Status da Rede
        <:subtitle>Informações do ponto de acesso Wi-Fi local.</:subtitle>
      </.header>

      <div :if={@status.modo == :simulado} class="mt-4 rounded-box bg-warning/20 px-4 py-2 text-sm">
        Modo simulado — não há Raspberry Pi conectado. Estes dados são gerados
        localmente para permitir testar a interface antes do hardware chegar.
      </div>

      <.list>
        <:item title="SSID">{@status.ssid}</:item>
        <:item title="IP do ponto de acesso">{@status.ip}</:item>
        <:item title="Clientes conectados">{@status.clientes_conectados}</:item>
        <:item title="Modo">{modo_label(@status.modo)}</:item>
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

  defp modo_label(:simulado), do: "Simulado (dev)"
  defp modo_label(:real), do: "Real (hardware)"
end
