defmodule EmergencyServer.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :author, :string
    field :content, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:author, :content])
    |> validate_required([:author, :content])
    |> validate_length(:author, max: 40)
    |> validate_length(:content, max: 500)
  end
end
