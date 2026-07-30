defmodule ServidorEmergenciaWeb.ChatLive do
  use ServidorEmergenciaWeb, :live_view

  alias ServidorEmergencia.Chat
  alias ServidorEmergencia.Chat.Mensagem

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Chat da Rede Local
        <:subtitle>Converse com quem estiver conectado neste mesmo Wi-Fi, em tempo real.</:subtitle>
      </.header>

      <div
        :if={@nome == nil}
        class="mt-6"
      >
        <.form for={@nome_form} phx-submit="entrar">
          <.input field={@nome_form[:nome]} type="text" label="Como você quer ser chamado?" />
          <.button variant="primary" class="mt-2">Entrar no chat</.button>
        </.form>
      </div>

      <div :if={@nome != nil}>
        <div
          id="mensagens"
          phx-update="stream"
          class="mt-6 h-96 overflow-y-auto space-y-2 rounded-box bg-base-200 p-4"
        >
          <div :for={{id, mensagem} <- @streams.mensagens} id={id}>
            <span class="font-semibold">{mensagem.autor}:</span>
            <span>{mensagem.conteudo}</span>
          </div>
        </div>

        <.form for={@form} id="mensagem-form" phx-hook="ResetOnEvent" phx-submit="enviar" class="mt-4 flex gap-2">
          <.input field={@form[:conteudo]} type="text" placeholder="Escreva uma mensagem..." />
          <.button variant="primary">Enviar</.button>
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
     |> assign(:nome, nil)
     |> assign(:nome_form, to_form(%{"nome" => ""}, as: :nome))
     |> assign(:form, to_form(Chat.change_mensagem(%Mensagem{})))
     |> stream(:mensagens, [])}
  end

  @impl true
  def handle_event("entrar", %{"nome" => %{"nome" => nome}}, socket) do
    nome = String.trim(nome)

    if nome == "" do
      {:noreply, socket}
    else
      {:noreply,
       socket
       |> assign(:nome, nome)
       |> stream(:mensagens, Chat.list_mensagens_recentes())}
    end
  end

  def handle_event("enviar", %{"mensagem" => %{"conteudo" => conteudo}}, socket) do
    attrs = %{"autor" => socket.assigns.nome, "conteudo" => conteudo}

    case Chat.enviar_mensagem(attrs) do
      {:ok, _mensagem} ->
        {:noreply,
         socket
         |> assign(:form, to_form(Chat.change_mensagem(%Mensagem{})))
         |> push_event("reset_form", %{})}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  @impl true
  def handle_info({:nova_mensagem, mensagem}, socket) do
    {:noreply, stream_insert(socket, :mensagens, mensagem)}
  end
end
