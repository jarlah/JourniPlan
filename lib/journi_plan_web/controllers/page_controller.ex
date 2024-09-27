defmodule JourniPlanWeb.PageController do
  use JourniPlanWeb, :controller
  alias JourniPlan.Itineraries
  alias JourniPlan.Repo
  alias JourniPlan.Itineraries

  def home(conn, _params) do
    if current_user = conn.assigns[:current_user] do
      itineraries = Itineraries.list_itineraries() |> Repo.preload([:journal_entries, :activities])
      render(conn, :home, layout: false, itineraries: itineraries, current_user: current_user)
    else
      render(conn, :home, layout: false)
    end
  end
end
