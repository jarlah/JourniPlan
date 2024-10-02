defmodule JourniPlanWeb.JournalEntryLive.Show do
  use JourniPlanWeb, :live_view

  alias JourniPlan.Itineraries

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:journal_entry, Itineraries.get_journal_entry!(id))}
  end

  defp page_title(:show), do: "Show Journal entry"
  defp page_title(:edit), do: "Edit Journal entry"
end
