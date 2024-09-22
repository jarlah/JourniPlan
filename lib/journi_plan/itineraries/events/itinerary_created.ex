defmodule JourniPlan.Itineraries.Events.ItineraryCreated do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :name,
    :description,
    :user_id
  ]
end
