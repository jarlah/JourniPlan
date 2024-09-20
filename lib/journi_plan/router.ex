defmodule JourniPlan.Router do
  use Commanded.Commands.Router

  alias JourniPlan.Itineraries.Aggregates.Itinerary
  alias JourniPlan.Itineraries.Commands.CreateItinerary

  dispatch([CreateItinerary], to: Itinerary, identity: :uuid)
end
