defmodule JourniPlanWeb.EntryLive.Index do
  use JourniPlanWeb, :live_view

  alias JourniPlan.Journals
  alias JourniPlan.Journals.Entry

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :entries, Journals.list_entries())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Entry")
    |> assign(:entry, Journals.get_entry!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Entry")
    |> assign(:entry, %Entry{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Entries")
    |> assign(:entry, nil)
  end

  @impl true
  def handle_info({JourniPlanWeb.EntryLive.FormComponent, {:saved, entry}}, socket) do
    {:noreply, stream_insert(socket, :entries, entry)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    entry = Journals.get_entry!(id)
    {:ok, _} = Journals.delete_entry(entry)

    {:noreply, stream_delete(socket, :entries, entry)}
  end
end
