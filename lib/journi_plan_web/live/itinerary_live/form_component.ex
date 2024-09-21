defmodule JourniPlanWeb.ItineraryLive.FormComponent do
  use JourniPlanWeb, :live_component

  alias JourniPlan.Itineraries
  alias JourniPlan.Itineraries.Commands.CreateItinerary
  alias JourniPlan.Itineraries.Commands.UpdateItinerary

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
  def update(%{itinerary: _itinerary, action: :new} = assigns, socket) do
    changeset = CreateItinerary.changeset(%CreateItinerary{}, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, to_form(changeset, as: "itinerary"))}
  end

  @impl true
  def update(%{itinerary: itinerary, action: :edit} = assigns, socket) do
    changeset = UpdateItinerary.changeset(%UpdateItinerary{uuid: itinerary.uuid}, Map.from_struct(itinerary))

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, to_form(changeset, as: "itinerary"))}
  end

  @impl true
  def handle_event("validate", %{"itinerary" => itinerary_params}, socket) do
    changeset =
      case socket.assigns.action do
        :new -> CreateItinerary.changeset(%CreateItinerary{}, itinerary_params)
        :edit -> UpdateItinerary.changeset(%UpdateItinerary{uuid: socket.assigns.itinerary.uuid}, itinerary_params)
      end

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
    case Itineraries.create_itinerary(itinerary_params) do
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
