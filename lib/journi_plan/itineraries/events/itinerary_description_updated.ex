defmodule JourniPlan.Itineraries.Events.ItineraryDescriptionUpdated do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :description
  ]
end
