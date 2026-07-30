defmodule EmergencyServerWeb.NoticeLive.Show do
  use EmergencyServerWeb, :live_view

  alias EmergencyServer.Notices

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@notice.title}
        <:subtitle>Notice posted on the community board.</:subtitle>
        <:actions>
          <.button navigate={~p"/notices"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/notices/#{@notice}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit notice
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Title">{@notice.title}</:item>
        <:item title="Category">{@notice.category}</:item>
        <:item title="Author">{@notice.author}</:item>
        <:item title="Content">{@notice.content}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Notice")
     |> assign(:notice, Notices.get_notice!(id))}
  end
end
