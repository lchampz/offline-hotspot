defmodule EmergencyServer.Repo do
  use Ecto.Repo,
    otp_app: :emergency_server,
    adapter: Ecto.Adapters.SQLite3
end
