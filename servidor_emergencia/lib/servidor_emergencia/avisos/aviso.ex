defmodule ServidorEmergencia.Avisos.Aviso do
  use Ecto.Schema
  import Ecto.Changeset

  @categorias ~w(notice help_request health_notice)

  schema "avisos" do
    field :titulo, :string
    field :categoria, :string
    field :autor, :string
    field :conteudo, :string

    timestamps(type: :utc_datetime)
  end

  def categorias, do: @categorias

  @doc false
  def changeset(aviso, attrs) do
    aviso
    |> cast(attrs, [:titulo, :categoria, :autor, :conteudo])
    |> validate_required([:titulo, :categoria, :autor, :conteudo])
    |> validate_inclusion(:categoria, @categorias)
  end
end
