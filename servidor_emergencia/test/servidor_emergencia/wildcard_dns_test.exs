defmodule ServidorEmergencia.WildcardDnsTest do
  use ExUnit.Case, async: true

  alias ServidorEmergencia.WildcardDns

  @answer_ip {192, 168, 24, 1}

  setup do
    name = :"wildcard_dns_test_#{System.unique_integer([:positive])}"
    {:ok, pid} = WildcardDns.start_link(name: name, port: 0, answer_ip: @answer_ip)
    port = WildcardDns.port(name)

    {:ok, client} = :gen_udp.open(0, [:binary, active: false])
    on_exit(fn -> :gen_udp.close(client) end)

    %{pid: pid, port: port, client: client}
  end

  test "resolves any A query to the configured IP", %{port: port, client: client} do
    query = build_query(1234, "connectivitycheck.gstatic.com")
    :ok = :gen_udp.send(client, {127, 0, 0, 1}, port, query)

    assert {:ok, {_ip, _port, response}} = :gen_udp.recv(client, 0, 1000)
    assert {:ok, 1234, [@answer_ip]} = parse_response(response)
  end

  test "answers a second arbitrary domain the same way", %{port: port, client: client} do
    query = build_query(42, "captive.apple.com")
    :ok = :gen_udp.send(client, {127, 0, 0, 1}, port, query)

    assert {:ok, {_ip, _port, response}} = :gen_udp.recv(client, 0, 1000)
    assert {:ok, 42, [@answer_ip]} = parse_response(response)
  end

  defp build_query(id, domain) do
    header = <<id::16, 0x0100::16, 1::16, 0::16, 0::16, 0::16>>
    question = encode_name(domain) <> <<1::16, 1::16>>
    header <> question
  end

  defp encode_name(domain) do
    domain
    |> String.split(".")
    |> Enum.map(fn label -> <<byte_size(label), label::binary>> end)
    |> IO.iodata_to_binary()
    |> Kernel.<>(<<0>>)
  end

  defp parse_response(<<id::16, _flags::16, 1::16, ancount::16, _::16, _::16, rest::binary>>) do
    {:ok, _qtype, _qclass, qlen} = parse_question(rest, 0)
    <<_question::binary-size(qlen), answers::binary>> = rest
    ips = parse_answers(answers, ancount)
    {:ok, id, ips}
  end

  defp parse_question(<<0, type::16, class::16, _rest::binary>>, acc) do
    {:ok, type, class, acc + 1 + 4}
  end

  defp parse_question(<<len, _label::binary-size(len), rest::binary>>, acc) do
    parse_question(rest, acc + 1 + len)
  end

  defp parse_answers(_binary, 0), do: []

  defp parse_answers(
         <<0xC0, 0x0C, 1::16, 1::16, _ttl::32, 4::16, a, b, c, d, rest::binary>>,
         count
       ) do
    [{a, b, c, d} | parse_answers(rest, count - 1)]
  end
end
