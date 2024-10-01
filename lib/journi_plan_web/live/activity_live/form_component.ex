defmodule JourniPlanWeb.ActivityLive.FormComponent do
  use JourniPlanWeb, :live_component

  alias JourniPlan.Itineraries

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage activity records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="activity-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:start_time]} type="datetime-local" label="Start time" />
        <.input field={@form[:end_time]} type="datetime-local" label="End time" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Activity</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{activity: activity, itinerary_id: itinerary_id, action: action} = assigns, socket) do
    IO.puts("Itinerary ID in FormComponent: #{inspect(itinerary_id)}")
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, to_form(Itineraries.change_activity(activity, action), as: "activity"))}

  end

  @impl true
  def handle_event("validate", %{"activity" => activity_params}, socket) do
    changeset = Itineraries.change_activity(socket.assigns.activity, socket.assigns.action, activity_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate, as: "activity"))}
  end

  def handle_event("save", %{"activity" => activity_params}, socket) do
    save_activity(socket, socket.assigns.action, activity_params)
  end

  defp save_activity(socket, :edit, activity_params) do
    case Itineraries.update_activity(socket.assigns.activity, activity_params) do
      {:ok, activity} ->
        notify_parent({:saved, activity})

        {:noreply,
         socket
         |> put_flash(:info, "Activity updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_activity(socket, :new, activity_params) do
    user_id = socket.assigns.current_user.id
    activity_params = Map.put(activity_params, "user_id", user_id)
    activity_params = Map.put(activity_params, "itinerary_uuid", socket.assigns.itinerary_id)

    case Itineraries.create_activity(activity_params) do
      {:ok, activity} ->
        notify_parent({:saved, activity})

        {:noreply,
         socket
         |> put_flash(:info, "Activity created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
