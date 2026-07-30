defmodule ServidorEmergenciaWeb.AvisoLive.Form do
  use ServidorEmergenciaWeb, :live_view

  alias ServidorEmergencia.Avisos
  alias ServidorEmergencia.Avisos.Aviso

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Post a notice, a help request, or a health notice.</:subtitle>
      </.header>

      <.form for={@form} id="aviso-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:titulo]} type="text" label="Title" />
        <.input
          field={@form[:categoria]}
          type="select"
          label="Category"
          prompt="Select a category"
          options={[
            {"Notice", "notice"},
            {"Help request", "help_request"},
            {"Health notice", "health_notice"}
          ]}
        />
        <.input field={@form[:autor]} type="text" label="Author" />
        <.input field={@form[:conteudo]} type="textarea" label="Content" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save notice</.button>
          <.button navigate={return_path(@return_to, @aviso)}>Cancel</.button>
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
    aviso = Avisos.get_aviso!(id)

    socket
    |> assign(:page_title, "Edit notice")
    |> assign(:aviso, aviso)
    |> assign(:form, to_form(Avisos.change_aviso(aviso)))
  end

  defp apply_action(socket, :new, _params) do
    aviso = %Aviso{}

    socket
    |> assign(:page_title, "New notice")
    |> assign(:aviso, aviso)
    |> assign(:form, to_form(Avisos.change_aviso(aviso)))
  end

  @impl true
  def handle_event("validate", %{"aviso" => aviso_params}, socket) do
    changeset = Avisos.change_aviso(socket.assigns.aviso, aviso_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"aviso" => aviso_params}, socket) do
    save_aviso(socket, socket.assigns.live_action, aviso_params)
  end

  defp save_aviso(socket, :edit, aviso_params) do
    case Avisos.update_aviso(socket.assigns.aviso, aviso_params) do
      {:ok, aviso} ->
        {:noreply,
         socket
         |> put_flash(:info, "Notice updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, aviso))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_aviso(socket, :new, aviso_params) do
    case Avisos.create_aviso(aviso_params) do
      {:ok, aviso} ->
        {:noreply,
         socket
         |> put_flash(:info, "Notice created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, aviso))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _aviso), do: ~p"/avisos"
  defp return_path("show", aviso), do: ~p"/avisos/#{aviso}"
end
