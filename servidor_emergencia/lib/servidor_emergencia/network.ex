defmodule ServidorEmergencia.Network do
  @moduledoc """
  Interface única de status da rede Wi-Fi/AP. Quem consome (a LiveView de
  status, por exemplo) não sabe se está falando com o simulador (rodando
  no Mac, sem hardware) ou com a implementação real (no Raspberry Pi).

  Isso é o que permite programar contra a interface agora — antes do
  hardware chegar — e trocar só a implementação depois, sem tocar na UI.
  """

  @type status :: %{
          ssid: String.t(),
          ip: String.t(),
          clientes_conectados: non_neg_integer(),
          modo: :simulado | :real
        }

  @callback status() :: status()

  def status, do: impl().status()

  defp impl do
    Application.get_env(:servidor_emergencia, :network_adapter, ServidorEmergencia.Network.Mock)
  end
end
