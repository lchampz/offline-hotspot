defmodule EmergencyServer.Repo.Migrations.CreateNotices do
  use Ecto.Migration

  def change do
    create table(:notices) do
      add :title, :string
      add :category, :string
      add :author, :string
      add :content, :text

      timestamps(type: :utc_datetime)
    end
  end
end
