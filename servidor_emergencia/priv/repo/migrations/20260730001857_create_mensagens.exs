defmodule ServidorEmergencia.Repo.Migrations.CreateMensagens do
  use Ecto.Migration

  def change do
    create table(:mensagens) do
      add :autor, :string
      add :conteudo, :text

      timestamps(type: :utc_datetime)
    end
  end
end
