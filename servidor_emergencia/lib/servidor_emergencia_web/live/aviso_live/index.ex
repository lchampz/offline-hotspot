defmodule ServidorEmergenciaWeb.AvisoLive.Index do
  use ServidorEmergenciaWeb, :live_view

  alias ServidorEmergencia.Avisos

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Notice Board
        <:actions>
          <.button variant="primary" navigate={~p"/avisos/new"}>
            <.icon name="hero-plus" /> New notice
          </.button>
        </:actions>
      </.header>

      <.table
        id="avisos"
        rows={@streams.avisos}
        row_click={fn {_id, aviso} -> JS.navigate(~p"/avisos/#{aviso}") end}
      >
        <:col :let={{_id, aviso}} label="Title">{aviso.titulo}</:col>
        <:col :let={{_id, aviso}} label="Category">{categoria_label(aviso.categoria)}</:col>
        <:col :let={{_id, aviso}} label="Author">{aviso.autor}</:col>
        <:col :let={{_id, aviso}} label="Content">{aviso.conteudo}</:col>
        <:action :let={{_id, aviso}}>
          <div class="sr-only">
            <.link navigate={~p"/avisos/#{aviso}"}>View</.link>
          </div>
          <.link navigate={~p"/avisos/#{aviso}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, aviso}}>
          <.link
            phx-click={JS.push("delete", value: %{id: aviso.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Notice Board")
     |> stream(:avisos, list_avisos())}
  end

  defp categoria_label("notice"), do: "Notice"
  defp categoria_label("help_request"), do: "Help request"
  defp categoria_label("health_notice"), do: "Health notice"
  defp categoria_label(other), do: other

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    aviso = Avisos.get_aviso!(id)
    {:ok, _} = Avisos.delete_aviso(aviso)

    {:noreply, stream_delete(socket, :avisos, aviso)}
  end

  defp list_avisos() do
    Avisos.list_avisos()
  end
end
