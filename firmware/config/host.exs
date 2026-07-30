import Config

# Add configuration that is only needed when running on the host here.

# No host, usamos uma porta alta (não requer privilégio de root) e
# respondemos com localhost — assim dá pra abrir o IP resolvido no
# navegador e fechar o ciclo inteiro do captive portal, sem hardware.
config :servidor_emergencia_firmware, :wildcard_dns,
  # 5353 é a porta padrão de mDNS/Bonjour, já ocupada no macOS — usamos
  # uma porta alta qualquer só para a demonstração local.
  port: 15353,
  answer_ip: {127, 0, 0, 1}

# Sobe o Phoenix igual ao "mix phx.server" normal, só que dentro do
# supervisor do firmware simulado (é isso que vai rodar de verdade dentro
# do Nerves lá no Pi).
config :servidor_emergencia, ServidorEmergenciaWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  # phoenix_live_reload é dep :dev do servidor_emergencia e não é puxada
  # quando ele entra como path-dependency aqui; o hot reload de código
  # roda pelo `listeners: [Phoenix.CodeReloader]` já configurado no mix.exs.
  code_reloader: false,
  debug_errors: true,
  server: true

config :servidor_emergencia, ServidorEmergencia.Repo,
  database: Path.expand("../../servidor_emergencia/servidor_emergencia_dev.db", __DIR__),
  pool_size: 5,
  stacktrace: true

config :servidor_emergencia, dev_routes: true
config :servidor_emergencia, network_adapter: ServidorEmergencia.Network.Mock

config :logger, :default_formatter, format: "[$level] $message\n"

config :nerves_runtime,
  kv_backend:
    {Nerves.Runtime.KVBackend.InMemory,
     contents: %{
       # The KV store on Nerves systems is typically read from UBoot-env, but
       # this allows us to use a pre-populated InMemory store when running on
       # host for development and testing.
       #
       # https://nerves-runtime.hexdocs.pm/readme.html#using-nerves_runtime-in-tests
       # https://nerves-runtime.hexdocs.pm/readme.html#nerves-system-and-firmware-metadata

       "nerves_fw_active" => "a",
       "a.nerves_fw_architecture" => "generic",
       "a.nerves_fw_description" => "N/A",
       "a.nerves_fw_platform" => "host",
       "a.nerves_fw_version" => "0.0.0"
     }}
