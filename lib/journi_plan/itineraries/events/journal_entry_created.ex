defmodule JourniPlan.Itineraries.Events.JournalEntryCreated do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :title,
    :body,
    :entry_date,
    :itinerary_id,
    :activity_id,
    :user_id
  ]
end
