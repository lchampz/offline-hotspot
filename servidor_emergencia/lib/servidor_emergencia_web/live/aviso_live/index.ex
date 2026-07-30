defmodule ServidorEmergenciaWeb.AvisoLive.Index do
  use ServidorEmergenciaWeb, :live_view

  alias ServidorEmergencia.Avisos

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Quadro de Avisos
        <:actions>
          <.button variant="primary" navigate={~p"/avisos/new"}>
            <.icon name="hero-plus" /> Novo aviso
          </.button>
        </:actions>
      </.header>

      <.table
        id="avisos"
        rows={@streams.avisos}
        row_click={fn {_id, aviso} -> JS.navigate(~p"/avisos/#{aviso}") end}
      >
        <:col :let={{_id, aviso}} label="Título">{aviso.titulo}</:col>
        <:col :let={{_id, aviso}} label="Categoria">{categoria_label(aviso.categoria)}</:col>
        <:col :let={{_id, aviso}} label="Autor">{aviso.autor}</:col>
        <:col :let={{_id, aviso}} label="Conteúdo">{aviso.conteudo}</:col>
        <:action :let={{_id, aviso}}>
          <div class="sr-only">
            <.link navigate={~p"/avisos/#{aviso}"}>Ver</.link>
          </div>
          <.link navigate={~p"/avisos/#{aviso}/edit"}>Editar</.link>
        </:action>
        <:action :let={{id, aviso}}>
          <.link
            phx-click={JS.push("delete", value: %{id: aviso.id}) |> hide("##{id}")}
            data-confirm="Tem certeza?"
          >
            Excluir
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
     |> assign(:page_title, "Quadro de Avisos")
     |> stream(:avisos, list_avisos())}
  end

  defp categoria_label("recado"), do: "Recado"
  defp categoria_label("pedido_ajuda"), do: "Pedido de ajuda"
  defp categoria_label("aviso_sanitario"), do: "Aviso sanitário"
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
