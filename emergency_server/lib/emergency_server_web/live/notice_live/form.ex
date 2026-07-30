defmodule EmergencyServerWeb.NoticeLive.Form do
  use EmergencyServerWeb, :live_view

  alias EmergencyServer.Notices
  alias EmergencyServer.Notices.Notice

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Post a notice, a help request, or a health notice.</:subtitle>
      </.header>

      <.form for={@form} id="notice-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:title]} type="text" label="Title" />
        <.input
          field={@form[:category]}
          type="select"
          label="Category"
          prompt="Select a category"
          options={[
            {"Notice", "notice"},
            {"Help request", "help_request"},
            {"Health notice", "health_notice"}
          ]}
        />
        <.input field={@form[:author]} type="text" label="Author" />
        <.input field={@form[:content]} type="textarea" label="Content" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save notice</.button>
          <.button navigate={return_path(@return_to, @notice)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    notice = Notices.get_notice!(id)

    socket
    |> assign(:page_title, "Edit notice")
    |> assign(:notice, notice)
    |> assign(:form, to_form(Notices.change_notice(notice)))
  end

  defp apply_action(socket, :new, _params) do
    notice = %Notice{}

    socket
    |> assign(:page_title, "New notice")
    |> assign(:notice, notice)
    |> assign(:form, to_form(Notices.change_notice(notice)))
  end

  @impl true
  def handle_event("validate", %{"notice" => notice_params}, socket) do
    changeset = Notices.change_notice(socket.assigns.notice, notice_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"notice" => notice_params}, socket) do
    save_notice(socket, socket.assigns.live_action, notice_params)
  end

  defp save_notice(socket, :edit, notice_params) do
    case Notices.update_notice(socket.assigns.notice, notice_params) do
      {:ok, notice} ->
        {:noreply,
         socket
         |> put_flash(:info, "Notice updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, notice))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_notice(socket, :new, notice_params) do
    case Notices.create_notice(notice_params) do
      {:ok, notice} ->
        {:noreply,
         socket
         |> put_flash(:info, "Notice created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, notice))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _notice), do: ~p"/notices"
  defp return_path("show", notice), do: ~p"/notices/#{notice}"
end
