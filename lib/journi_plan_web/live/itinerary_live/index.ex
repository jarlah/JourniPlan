defmodule JourniPlanWeb.ItineraryLive.Index do
  use JourniPlanWeb, :live_view

  alias JourniPlan.Itineraries
  alias JourniPlan.Itineraries.Projections.Itinerary

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    {
      :ok,
      socket
      |> assign(:current_user, current_user)
      |> stream_configure(:itineraries, dom_id: & &1.uuid)
      |> stream(:itineraries, Itineraries.list_user_itineraries(current_user.id))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Itinerary")
    |> assign(:itinerary, Itineraries.get_itinerary!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Itinerary")
    |> assign(:itinerary, %Itinerary{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Itineraries")
    |> assign(:itinerary, nil)
  end

  @impl true
  def handle_info({JourniPlanWeb.ItineraryLive.FormComponent, {:saved, itinerary}}, socket) do
    {:noreply, stream_insert(socket, :itineraries, itinerary)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    itinerary = Itineraries.get_itinerary!(id)
    {:ok, _} = Itineraries.delete_itinerary(itinerary)

    {:noreply, stream_delete(socket, :itineraries, itinerary)}
  end
end
