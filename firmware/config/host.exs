import Config

# Add configuration that is only needed when running on the host here.

# On the host, we use a high port (doesn't require root) and answer with
# localhost — so you can open the resolved IP in a browser and close the
# whole captive portal loop without any hardware.
config :servidor_emergencia_firmware, :wildcard_dns,
  # 5353 is the standard mDNS/Bonjour port, already taken on macOS — we
  # use an arbitrary high port just for the local demo.
  port: 15353,
  answer_ip: {127, 0, 0, 1}

# Boots Phoenix just like a normal "mix phx.server", except inside the
# simulated firmware's supervisor (this is what will actually run inside
# Nerves on the Pi).
config :servidor_emergencia, ServidorEmergenciaWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  # phoenix_live_reload is a :dev dep of servidor_emergencia and isn't
  # pulled in when it's used as a path-dependency here; code hot reload
  # runs through the `listeners: [Phoenix.CodeReloader]` already set in
  # mix.exs.
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
