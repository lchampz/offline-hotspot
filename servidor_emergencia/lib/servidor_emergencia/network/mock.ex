defmodule ServidorEmergencia.Network.Mock do
  @moduledoc """
  Simulador de status de rede, usado quando não há Raspberry Pi (dev no
  Mac). Varia o número de "clientes conectados" periodicamente só para a
  tela de status não ficar estática enquanto se testa a interface.
  """

  @behaviour ServidorEmergencia.Network

  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl ServidorEmergencia.Network
  def status do
    %{
      ssid: "REDE-DE-EMERGENCIA-LOCAL (simulado)",
      ip: "127.0.0.1",
      clientes_conectados: GenServer.call(__MODULE__, :clientes_conectados),
      modo: :simulado
    }
  end

  @impl true
  def init(_opts) do
    schedule_tick()
    {:ok, %{clientes: 2}}
  end

  @impl true
  def handle_call(:clientes_conectados, _from, state) do
    {:reply, state.clientes, state}
  end

  @impl true
  def handle_info(:tick, state) do
    schedule_tick()
    variacao = Enum.random([-1, 0, 0, 1])
    novo = (state.clientes + variacao) |> max(0) |> min(6)
    {:noreply, %{state | clientes: novo}}
  end

  defp schedule_tick, do: Process.send_after(self(), :tick, 4_000)
end
