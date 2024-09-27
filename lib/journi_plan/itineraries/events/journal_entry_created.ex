defmodule JourniPlan.Itineraries.Events.JournalEntryCreated do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :title,
    :body,
    :entry_date,
    :itinerary_uuid,
    :activity_uuid,
    :user_id
  ]
end
