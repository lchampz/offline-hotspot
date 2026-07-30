defmodule EmergencyServer.Notices.Notice do
  use Ecto.Schema
  import Ecto.Changeset

  @categories ~w(notice help_request health_notice)

  schema "notices" do
    field :title, :string
    field :category, :string
    field :author, :string
    field :content, :string

    timestamps(type: :utc_datetime)
  end

  def categories, do: @categories

  @doc false
  def changeset(notice, attrs) do
    notice
    |> cast(attrs, [:title, :category, :author, :content])
    |> validate_required([:title, :category, :author, :content])
    |> validate_inclusion(:category, @categories)
  end
end
