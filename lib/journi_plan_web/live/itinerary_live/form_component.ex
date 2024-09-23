defmodule JourniPlanWeb.ItineraryLive.FormComponent do
  use JourniPlanWeb, :live_component

  alias JourniPlan.Itineraries

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage itinerary records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="itinerary-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Itinerary</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{itinerary: itinerary, action: action} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, to_form(Itineraries.change_itinerary(itinerary, action), as: "itinerary"))}
  end

  @impl true
  def handle_event("validate", %{"itinerary" => itinerary_params}, socket) do
    changeset = Itineraries.change_itinerary(socket.assigns.itinerary, socket.assigns.action, itinerary_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate, as: "itinerary"))}
  end

  def handle_event("save", %{"itinerary" => itinerary_params}, socket) do
    save_itinerary(socket, socket.assigns.action, itinerary_params)
  end

  defp save_itinerary(socket, :edit, itinerary_params) do
    case Itineraries.update_itinerary(socket.assigns.itinerary, itinerary_params) do
      {:ok, itinerary} ->
        notify_parent({:saved, itinerary})

        {:noreply,
         socket
         |> put_flash(:info, "Itinerary updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset, as: "itinerary"))}
    end
  end

  defp save_itinerary(socket, :new, itinerary_params) do
    user_id = socket.assigns.current_user.id
    updated_params = Map.put(itinerary_params, "user_id", user_id)

    case Itineraries.create_itinerary(updated_params) do
      {:ok, itinerary} ->
        notify_parent({:saved, itinerary})

        {:noreply,
         socket
         |> put_flash(:info, "Itinerary created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset, as: "itinerary"))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
