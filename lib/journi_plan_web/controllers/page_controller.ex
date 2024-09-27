defmodule JourniPlanWeb.PageController do
  use JourniPlanWeb, :controller
  alias JourniPlan.Itineraries
  alias JourniPlan.Repo

  def home(conn, _params) do
    itineraries = Itineraries.list_itineraries() |> Repo.preload([:journal_entries, :activities])
    render(conn, :home, itineraries: itineraries, layout: false)
  end
end
