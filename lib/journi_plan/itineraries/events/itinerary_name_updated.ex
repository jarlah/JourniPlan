defmodule JourniPlan.Itineraries.Events.ItineraryNameUpdated do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :name
  ]
end
