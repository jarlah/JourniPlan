defmodule JourniPlan.Itineraries.Supervisor do
  use Supervisor

  alias JourniPlan.Itineraries

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init(
      [
        Itineraries.Projectors.Itinerary
      ],
      strategy: :one_for_one
    )
  end
end
