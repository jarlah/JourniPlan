defmodule JourniPlan.Itineraries.Events.ActivityCreated do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :name,
    :description,
    :start_time,
    :end_time,
    :itinerary_uuid,
    :user_id
  ]
end
