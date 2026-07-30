defmodule EmergencyServerWeb.NoticeLive.Index do
  use EmergencyServerWeb, :live_view

  alias EmergencyServer.Notices

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Notice Board
        <:actions>
          <.button variant="primary" navigate={~p"/notices/new"}>
            <.icon name="hero-plus" /> New notice
          </.button>
        </:actions>
      </.header>

      <.table
        id="notices"
        rows={@streams.notices}
        row_click={fn {_id, notice} -> JS.navigate(~p"/notices/#{notice}") end}
      >
        <:col :let={{_id, notice}} label="Title">{notice.title}</:col>
        <:col :let={{_id, notice}} label="Category">{category_label(notice.category)}</:col>
        <:col :let={{_id, notice}} label="Author">{notice.author}</:col>
        <:col :let={{_id, notice}} label="Content">{notice.content}</:col>
        <:action :let={{_id, notice}}>
          <div class="sr-only">
            <.link navigate={~p"/notices/#{notice}"}>View</.link>
          </div>
          <.link navigate={~p"/notices/#{notice}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, notice}}>
          <.link
            phx-click={JS.push("delete", value: %{id: notice.id}) |> hide("##{id}")}
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
     |> stream(:notices, list_notices())}
  end

  defp category_label("notice"), do: "Notice"
  defp category_label("help_request"), do: "Help request"
  defp category_label("health_notice"), do: "Health notice"
  defp category_label(other), do: other

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    notice = Notices.get_notice!(id)
    {:ok, _} = Notices.delete_notice(notice)

    {:noreply, stream_delete(socket, :notices, notice)}
  end

  defp list_notices() do
    Notices.list_notices()
  end
end
