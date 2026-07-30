defmodule ServidorEmergencia.Network.Real do
  @moduledoc """
  Implementação real, para quando o firmware roda no Raspberry Pi.

  SSID/IP vêm da configuração estática do VintageNet (não usamos DHCP no
  wlan0, então esses valores são conhecidos em tempo de build, não
  precisam ser consultados via API do VintageNet).

  A contagem de clientes conectados AINDA NÃO está implementada de
  verdade — isso exige ler o socket de controle do hostapd (algo como
  `iw dev wlan0 station dump`), o que só dá para validar com o Pi em mãos.
  Por enquanto retorna 0 para não fingir um dado que não temos.
  """

  @behaviour ServidorEmergencia.Network

  @impl ServidorEmergencia.Network
  def status do
    %{
      ssid: "REDE-DE-EMERGENCIA-LOCAL",
      ip: "192.168.24.1",
      clientes_conectados: 0,
      modo: :real
    }
  end
end
