defmodule JourniPlanWeb.JournalEntryLive.Index do
  use JourniPlanWeb, :live_view

  alias JourniPlan.Itineraries
  alias JourniPlan.Itineraries.JournalEntry

  @impl true
  def mount(params, _session, socket) do
    current_user = socket.assigns.current_user

    {
      :ok,
      socket
      |> assign(:current_user, current_user)
      |> assign(:itinerary_id, params["id"])
      |> stream_configure(:journal_entries, dom_id: & &1.uuid)
      |> stream(:journal_entries, Itineraries.list_user_journal_entries(current_user.id))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Journal entry")
    |> assign(:journal_entry, Itineraries.get_journal_entry!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Journal entry")
    |> assign(:journal_entry, %JournalEntry{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Journal entries")
    |> assign(:journal_entry, nil)
  end

  @impl true
  def handle_info({JourniPlanWeb.JournalEntryLive.FormComponent, {:saved, journal_entry}}, socket) do
    {:noreply, stream_insert(socket, :journal_entries, journal_entry)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    journal_entry = Itineraries.get_journal_entry!(id)
    {:ok, _} = Itineraries.delete_journal_entry(journal_entry)

    {:noreply, stream_delete(socket, :journal_entries, journal_entry)}
  end
end
