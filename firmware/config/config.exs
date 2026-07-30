# This file is responsible for configuring your application and its
# dependencies.
#
# This configuration file is loaded before any dependency and is restricted to
# this project.
import Config

# Enable the Nerves integration with Mix
Application.start(:nerves_bootstrap)

# Customize non-Elixir parts of the firmware. See
# https://nerves.hexdocs.pm/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Set the SOURCE_DATE_EPOCH date for reproducible builds.
# See https://reproducible-builds.org/docs/source-date-epoch/ for more information

config :nerves, source_date_epoch: "1785372114"

# Config do app Phoenix (servidor_emergencia/), replicada aqui porque o
# config.exs dele não é carregado automaticamente quando ele entra como
# dependência de um outro projeto Mix.
config :servidor_emergencia,
  ecto_repos: [ServidorEmergencia.Repo],
  generators: [timestamp_type: :utc_datetime]

config :servidor_emergencia, ServidorEmergenciaWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ServidorEmergenciaWeb.ErrorHTML, json: ServidorEmergenciaWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ServidorEmergencia.PubSub,
  live_view: [signing_salt: "oT8sEvPL"],
  secret_key_base: "5u6o+tWJGdifdMGy0W3fmZ8+XZmIdz4aM+rmLl5QYatIOjrQM6hf3suXeJlcFm3V"

config :phoenix_live_view, root_tag_attribute: "phx-r"
config :phoenix, :json_library, Jason

# Resolver DNS wildcard (ServidorEmergencia.WildcardDns) usado pelo captive
# portal. Cada ambiente sobrescreve porta/IP de resposta abaixo.
config :servidor_emergencia_firmware, :wildcard_dns,
  port: 53,
  answer_ip: {192, 168, 24, 1}

if Mix.target() == :host do
  import_config "host.exs"
else
  import_config "target.exs"
end
