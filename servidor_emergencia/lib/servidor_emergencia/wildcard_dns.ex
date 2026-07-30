defmodule ServidorEmergencia.WildcardDns do
  @moduledoc """
  A "wildcard" DNS resolver: answers any A query with a single configured
  IP.

  This is the missing piece for the captive portal to actually work:
  without a DNS server answering every domain, the phone's OS gets no
  response when trying to resolve its connectivity-check domains (e.g.
  `connectivitycheck.gstatic.com` or `captive.apple.com`) and never fires
  the portal pop-up.

  In Phase 3 (Nerves), this runs on the Raspberry Pi answering with the
  Pi's own IP, alongside the Phoenix HTTP catch-all. Here on a Mac
  (without hardware) it's used to validate the protocol logic without
  needing a real Wi-Fi AP.
  """

  use GenServer
  require Logger

  @type ip4 :: {0..255, 0..255, 0..255, 0..255}

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @doc "UDP port the resolver is listening on (useful when port: 0)."
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
        Logger.info("WildcardDns listening on port #{actual_port}, answering #{:inet.ntoa(answer_ip)}")
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

      # QR=1 AA=1 RD=1 RA=1, everything else zeroed — a simple authoritative reply
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
    # name via a pointer to offset 12 (start of the question section)
    <<0xC0, 0x0C, 1::16, 1::16, 60::32, 4::16, a, b, c, d>>
  end
end
