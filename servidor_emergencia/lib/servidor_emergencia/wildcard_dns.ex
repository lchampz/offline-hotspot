defmodule ServidorEmergencia.WildcardDns do
  @moduledoc """
  Resolver DNS "wildcard": responde qualquer consulta A com um único IP
  configurado.

  Essa é a peça que falta para o captive portal funcionar de verdade: sem
  um DNS respondendo qualquer domínio, o SO do celular não recebe resposta
  ao tentar resolver os domínios de teste de conectividade (por exemplo
  `connectivitycheck.gstatic.com` ou `captive.apple.com`) e não dispara o
  pop-up do portal.

  Na Fase 3 (Nerves), isso roda no Raspberry Pi respondendo com o IP do
  próprio Pi, junto do catch-all HTTP do Phoenix. Aqui no Mac (sem
  hardware) serve para validar a lógica do protocolo sem precisar de AP
  Wi-Fi real.
  """

  use GenServer
  require Logger

  @type ip4 :: {0..255, 0..255, 0..255, 0..255}

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @doc "Porta UDP em que o resolver está escutando (útil quando port: 0)."
  def port(server \\ __MODULE__) do
    GenServer.call(server, :port)
  end

  @impl true
  def init(opts) do
    port = Keyword.fetch!(opts, :port)
    answer_ip = Keyword.fetch!(opts, :answer_ip)

    case :gen_udp.open(port, [:binary, active: true]) do
      {:ok, socket} ->
        {:ok, actual_port} = :inet.port(socket)
        Logger.info("WildcardDns ouvindo na porta #{actual_port}, respondendo #{:inet.ntoa(answer_ip)}")
        {:ok, %{socket: socket, answer_ip: answer_ip, port: actual_port}}

      {:error, reason} ->
        {:stop, reason}
    end
  end

  @impl true
  def handle_call(:port, _from, state), do: {:reply, state.port, state}

  @impl true
  def handle_info({:udp, socket, ip, from_port, packet}, state) do
    case build_response(packet, state.answer_ip) do
      {:ok, response} -> :gen_udp.send(socket, ip, from_port, response)
      :error -> :ok
    end

    {:noreply, state}
  end

  @doc false
  def build_response(packet, answer_ip) do
    with <<id::16, _flags::16, 1::16, 0::16, 0::16, 0::16, rest::binary>> <- packet,
         {:ok, qtype, qclass, question_len} <- parse_question(rest, 0) do
      question_section = binary_part(rest, 0, question_len)
      ancount = if qtype == 1 and qclass == 1, do: 1, else: 0
      answers = if ancount == 1, do: build_a_answer(answer_ip), else: <<>>

      # QR=1 AA=1 RD=1 RA=1, resto zerado — resposta autoritativa simples
      flags = <<1::1, 0::4, 1::1, 0::1, 1::1, 1::1, 0::3, 0::4>>
      header = <<id::16, flags::bits, 1::16, ancount::16, 0::16, 0::16>>

      {:ok, header <> question_section <> answers}
    else
      _ -> :error
    end
  end

  defp parse_question(<<0, type::16, class::16, _rest::binary>>, acc) do
    {:ok, type, class, acc + 1 + 4}
  end

  defp parse_question(<<len, _label::binary-size(len), rest::binary>>, acc) do
    parse_question(rest, acc + 1 + len)
  end

  defp parse_question(_, _acc), do: :error

  defp build_a_answer({a, b, c, d}) do
    # nome via ponteiro para o offset 12 (início da seção de pergunta)
    <<0xC0, 0x0C, 1::16, 1::16, 60::32, 4::16, a, b, c, d>>
  end
end
