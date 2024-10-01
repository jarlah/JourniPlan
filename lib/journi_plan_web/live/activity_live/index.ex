defmodule JourniPlanWeb.ActivityLive.Index do
  use JourniPlanWeb, :live_view

  alias JourniPlan.Itineraries
  alias JourniPlan.Itineraries.Projections.Activity

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    {
      :ok,
      socket
      |> assign(:current_user, current_user)
      |> stream_configure(:activities, dom_id: & &1.uuid)
      |> stream(:activities, Itineraries.list_user_activities(current_user.id))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Activity")
    |> assign(:activity, Itineraries.get_activity!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Activity")
    |> assign(:activity, %Activity{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Activities")
    |> assign(:activity, nil)
  end

  @impl true
  def handle_info({JourniPlanWeb.ActivityLive.FormComponent, {:saved, activity}}, socket) do
    {:noreply, stream_insert(socket, :activities, activity)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity = Itineraries.get_activity!(id)
    {:ok, _} = Itineraries.delete_activity(activity)

    {:noreply, stream_delete(socket, :activities, activity)}
  end
end
