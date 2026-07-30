defmodule EmergencyServer.Chat do
  @moduledoc """
  Real-time chat context for the local network room.
  """

  import Ecto.Query, warn: false
  alias EmergencyServer.Repo
  alias EmergencyServer.Chat.Message

  @topic "chat:lobby"
  @historico 50

  def subscribe do
    Phoenix.PubSub.subscribe(EmergencyServer.PubSub, @topic)
  end

  def list_messages_recentes do
    Message
    |> order_by(desc: :inserted_at)
    |> limit(^@historico)
    |> Repo.all()
    |> Enum.reverse()
  end

  def send_message(attrs) do
    with {:ok, message} <-
           %Message{}
           |> Message.changeset(attrs)
           |> Repo.insert() do
      Phoenix.PubSub.broadcast(EmergencyServer.PubSub, @topic, {:nova_message, message})
      {:ok, message}
    end
  end

  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
