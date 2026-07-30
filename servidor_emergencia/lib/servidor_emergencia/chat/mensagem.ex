defmodule ServidorEmergencia.Chat.Mensagem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mensagens" do
    field :autor, :string
    field :conteudo, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(mensagem, attrs) do
    mensagem
    |> cast(attrs, [:autor, :conteudo])
    |> validate_required([:autor, :conteudo])
    |> validate_length(:autor, max: 40)
    |> validate_length(:conteudo, max: 500)
  end
end
