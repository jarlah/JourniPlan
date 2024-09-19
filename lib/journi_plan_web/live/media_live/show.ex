defmodule JourniPlanWeb.MediaLive.Show do
  use JourniPlanWeb, :live_view

  alias JourniPlan.Medias

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:media, Medias.get_media!(id))}
  end

  defp page_title(:show), do: "Show Media"
  defp page_title(:edit), do: "Edit Media"
end
