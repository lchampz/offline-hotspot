defmodule ServidorEmergencia.Repo do
  use Ecto.Repo,
    otp_app: :servidor_emergencia,
    adapter: Ecto.Adapters.SQLite3
end
