defmodule ServidorEmergencia.Chat do
  @moduledoc """
  Real-time chat context for the local network room.
  """

  import Ecto.Query, warn: false
  alias ServidorEmergencia.Repo
  alias ServidorEmergencia.Chat.Mensagem

  @topic "chat:lobby"
  @historico 50

  def subscribe do
    Phoenix.PubSub.subscribe(ServidorEmergencia.PubSub, @topic)
  end

  def list_mensagens_recentes do
    Mensagem
    |> order_by(desc: :inserted_at)
    |> limit(^@historico)
    |> Repo.all()
    |> Enum.reverse()
  end

  def enviar_mensagem(attrs) do
    with {:ok, mensagem} <-
           %Mensagem{}
           |> Mensagem.changeset(attrs)
           |> Repo.insert() do
      Phoenix.PubSub.broadcast(ServidorEmergencia.PubSub, @topic, {:nova_mensagem, mensagem})
      {:ok, mensagem}
    end
  end

  def change_mensagem(%Mensagem{} = mensagem, attrs \\ %{}) do
    Mensagem.changeset(mensagem, attrs)
  end
end
