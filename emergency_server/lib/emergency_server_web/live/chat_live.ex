defmodule EmergencyServerWeb.ChatLive do
  use EmergencyServerWeb, :live_view

  alias EmergencyServer.Chat
  alias EmergencyServer.Chat.Message

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Local Network Chat
        <:subtitle>Chat in real time with whoever else is connected to this same Wi-Fi.</:subtitle>
      </.header>

      <div
        :if={@name == nil}
        class="mt-6"
      >
        <.form for={@name_form} phx-submit="join">
          <.input field={@name_form[:name]} type="text" label="What should we call you?" />
          <.button variant="primary" class="mt-2">Join chat</.button>
        </.form>
      </div>

      <div :if={@name != nil}>
        <div
          id="messages"
          phx-update="stream"
          class="mt-6 h-96 overflow-y-auto space-y-2 rounded-box bg-base-200 p-4"
        >
          <div :for={{id, message} <- @streams.messages} id={id}>
            <span class="font-semibold">{message.author}:</span>
            <span>{message.content}</span>
          </div>
        </div>

        <.form for={@form} id="message-form" phx-hook="ResetOnEvent" phx-submit="send" class="mt-4 flex gap-2">
          <.input field={@form[:content]} type="text" placeholder="Write a message..." />
          <.button variant="primary">Send</.button>
        </.form>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Chat.subscribe()

    {:ok,
     socket
     |> assign(:name, nil)
     |> assign(:name_form, to_form(%{"name" => ""}, as: :name))
     |> assign(:form, to_form(Chat.change_message(%Message{})))
     |> stream(:messages, [])}
  end

  @impl true
  def handle_event("join", %{"name" => %{"name" => name}}, socket) do
    name = String.trim(name)

    if name == "" do
      {:noreply, socket}
    else
      {:noreply,
       socket
       |> assign(:name, name)
       |> stream(:messages, Chat.list_messages_recentes())}
    end
  end

  def handle_event("send", %{"message" => %{"content" => content}}, socket) do
    attrs = %{"author" => socket.assigns.name, "content" => content}

    case Chat.send_message(attrs) do
      {:ok, _message} ->
        {:noreply,
         socket
         |> assign(:form, to_form(Chat.change_message(%Message{})))
         |> push_event("reset_form", %{})}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  @impl true
  def handle_info({:nova_message, message}, socket) do
    {:noreply, stream_insert(socket, :messages, message)}
  end
end
