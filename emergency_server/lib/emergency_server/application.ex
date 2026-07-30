defmodule EmergencyServer.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EmergencyServerWeb.Telemetry,
      EmergencyServer.Repo,
      {Ecto.Migrator,
       repos: Application.fetch_env!(:emergency_server, :ecto_repos), skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:emergency_server, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EmergencyServer.PubSub}
    ] ++
      network_adapter_children() ++
      [
        # Start a worker by calling: EmergencyServer.Worker.start_link(arg)
        # {EmergencyServer.Worker, arg},
        # Start to serve requests, typically the last entry
        EmergencyServerWeb.Endpoint
      ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EmergencyServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EmergencyServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") == nil
  end

  # The Mock adapter runs as a GenServer (it needs a process, its state
  # varies over time). The Real adapter is just pure functions — nothing
  # to supervise.
  defp network_adapter_children do
    case Application.get_env(:emergency_server, :network_adapter, EmergencyServer.Network.Mock) do
      EmergencyServer.Network.Mock -> [EmergencyServer.Network.Mock]
      _ -> []
    end
  end
end
