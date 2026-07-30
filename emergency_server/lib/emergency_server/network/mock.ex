defmodule EmergencyServer.Network.Mock do
  @moduledoc """
  Network status simulator, used when there's no Raspberry Pi (dev on a
  Mac). Varies the "connected clients" count periodically just so the
  status screen isn't static while testing the interface.
  """

  @behaviour EmergencyServer.Network

  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl EmergencyServer.Network
  def status do
    %{
      ssid: "LOCAL-EMERGENCY-NETWORK (simulated)",
      ip: "127.0.0.1",
      connected_clients: GenServer.call(__MODULE__, :connected_clients),
      mode: :simulated
    }
  end

  @impl true
  def init(_opts) do
    schedule_tick()
    {:ok, %{clientes: 2}}
  end

  @impl true
  def handle_call(:connected_clients, _from, state) do
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
