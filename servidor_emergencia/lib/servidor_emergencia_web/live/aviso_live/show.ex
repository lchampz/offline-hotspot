defmodule ServidorEmergenciaWeb.AvisoLive.Show do
  use ServidorEmergenciaWeb, :live_view

  alias ServidorEmergencia.Avisos

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@aviso.titulo}
        <:subtitle>Aviso publicado no quadro comunitário.</:subtitle>
        <:actions>
          <.button navigate={~p"/avisos"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/avisos/#{@aviso}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Editar aviso
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Título">{@aviso.titulo}</:item>
        <:item title="Categoria">{@aviso.categoria}</:item>
        <:item title="Autor">{@aviso.autor}</:item>
        <:item title="Conteúdo">{@aviso.conteudo}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Aviso")
     |> assign(:aviso, Avisos.get_aviso!(id))}
  end
end
