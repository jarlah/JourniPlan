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
  def update(%{itinerary: itinerary} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Itineraries.change_itinerary(itinerary))
     end)}
  end

  @impl true
  def handle_event("validate", %{"itinerary" => itinerary_params}, socket) do
    changeset = Itineraries.change_itinerary(socket.assigns.itinerary, itinerary_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
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
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_itinerary(socket, :new, itinerary_params) do
    case Itineraries.create_itinerary(itinerary_params) do
      {:ok, itinerary} ->
        notify_parent({:saved, itinerary})

        {:noreply,
         socket
         |> put_flash(:info, "Itinerary created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
