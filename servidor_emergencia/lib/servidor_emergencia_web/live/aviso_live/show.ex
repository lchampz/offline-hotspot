defmodule ServidorEmergenciaWeb.AvisoLive.Show do
  use ServidorEmergenciaWeb, :live_view

  alias ServidorEmergencia.Avisos

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@aviso.titulo}
        <:subtitle>Notice posted on the community board.</:subtitle>
        <:actions>
          <.button navigate={~p"/avisos"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/avisos/#{@aviso}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit notice
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Title">{@aviso.titulo}</:item>
        <:item title="Category">{@aviso.categoria}</:item>
        <:item title="Author">{@aviso.autor}</:item>
        <:item title="Content">{@aviso.conteudo}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Notice")
     |> assign(:aviso, Avisos.get_aviso!(id))}
  end
end
