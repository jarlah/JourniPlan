defmodule JourniPlan.Router do
  use Commanded.Commands.Router

  alias JourniPlan.Itineraries.Aggregates.Itinerary
  alias JourniPlan.Itineraries.Commands.CreateItinerary
  alias JourniPlan.Itineraries.Commands.UpdateItinerary

  dispatch([CreateItinerary], to: Itinerary, identity: :uuid)
  dispatch([UpdateItinerary], to: Itinerary, identity: :uuid)
end
