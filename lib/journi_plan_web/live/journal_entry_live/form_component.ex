defmodule JourniPlanWeb.JournalEntryLive.FormComponent do
  use JourniPlanWeb, :live_component

  alias JourniPlan.Itineraries

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage journal_entry records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="journal_entry-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:body]} type="text" label="Body" />
        <.input field={@form[:entry_date]} type="datetime-local" label="Entry date" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Journal entry</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{journal_entry: journal_entry, action: action} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, to_form(Itineraries.change_journal_entry(journal_entry, action), as: "journal_entry"))}
  end

  @impl true
  def handle_event("validate", %{"journal_entry" => journal_entry_params}, socket) do
    changeset = Itineraries.change_journal_entry(socket.assigns.journal_entry, socket.assigns.action, journal_entry_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate, as: "journal_entry"))}
  end

  def handle_event("save", %{"journal_entry" => journal_entry_params}, socket) do
    save_journal_entry(socket, socket.assigns.action, journal_entry_params)
  end

  defp save_journal_entry(socket, :edit, journal_entry_params) do
    case Itineraries.update_journal_entry(socket.assigns.journal_entry, journal_entry_params) do
      {:ok, journal_entry} ->
        notify_parent({:saved, journal_entry})

        {:noreply,
         socket
         |> put_flash(:info, "Journal entry updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_journal_entry(socket, :new, journal_entry_params) do
    user_id = socket.assigns.current_user.id
    journal_entry_params = Map.put(journal_entry_params, "user_id", user_id)
    journal_entry_params = Map.put(journal_entry_params, "itinerary_uuid", socket.assigns.itinerary_id)
    case Itineraries.create_journal_entry(journal_entry_params) do
      {:ok, journal_entry} ->
        notify_parent({:saved, journal_entry})

        {:noreply,
         socket
         |> put_flash(:info, "Journal entry created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
