defmodule ServidorEmergencia.Repo.Migrations.CreateAvisos do
  use Ecto.Migration

  def change do
    create table(:avisos) do
      add :titulo, :string
      add :categoria, :string
      add :autor, :string
      add :conteudo, :text

      timestamps(type: :utc_datetime)
    end
  end
end
