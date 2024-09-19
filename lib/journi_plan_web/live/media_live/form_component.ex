defmodule JourniPlanWeb.MediaLive.FormComponent do
  use JourniPlanWeb, :live_component

  alias JourniPlan.Medias

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage media records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="media-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:media_type]} type="text" label="Media type" />
        <.input field={@form[:media_url]} type="text" label="Media url" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Media</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{media: media} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Medias.change_media(media))
     end)}
  end

  @impl true
  def handle_event("validate", %{"media" => media_params}, socket) do
    changeset = Medias.change_media(socket.assigns.media, media_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"media" => media_params}, socket) do
    save_media(socket, socket.assigns.action, media_params)
  end

  defp save_media(socket, :edit, media_params) do
    case Medias.update_media(socket.assigns.media, media_params) do
      {:ok, media} ->
        notify_parent({:saved, media})

        {:noreply,
         socket
         |> put_flash(:info, "Media updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_media(socket, :new, media_params) do
    case Medias.create_media(media_params) do
      {:ok, media} ->
        notify_parent({:saved, media})

        {:noreply,
         socket
         |> put_flash(:info, "Media created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
