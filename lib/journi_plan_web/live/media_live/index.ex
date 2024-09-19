defmodule JourniPlanWeb.MediaLive.Index do
  use JourniPlanWeb, :live_view

  alias JourniPlan.Medias
  alias JourniPlan.Medias.Media

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :medias, Medias.list_medias())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Media")
    |> assign(:media, Medias.get_media!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Media")
    |> assign(:media, %Media{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Medias")
    |> assign(:media, nil)
  end

  @impl true
  def handle_info({JourniPlanWeb.MediaLive.FormComponent, {:saved, media}}, socket) do
    {:noreply, stream_insert(socket, :medias, media)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    media = Medias.get_media!(id)
    {:ok, _} = Medias.delete_media(media)

    {:noreply, stream_delete(socket, :medias, media)}
  end
end
