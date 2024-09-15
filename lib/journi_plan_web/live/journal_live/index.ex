defmodule JourniPlanWeb.JournalLive.Index do
  use JourniPlanWeb, :live_view

  alias JourniPlan.Journals
  alias JourniPlan.Journals.Journal

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :journals, Journals.list_journals())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Journal")
    |> assign(:journal, Journals.get_journal!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Journal")
    |> assign(:journal, %Journal{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Journals")
    |> assign(:journal, nil)
  end

  @impl true
  def handle_info({JourniPlanWeb.JournalLive.FormComponent, {:saved, journal}}, socket) do
    {:noreply, stream_insert(socket, :journals, journal)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    journal = Journals.get_journal!(id)
    {:ok, _} = Journals.delete_journal(journal)

    {:noreply, stream_delete(socket, :journals, journal)}
  end
end
