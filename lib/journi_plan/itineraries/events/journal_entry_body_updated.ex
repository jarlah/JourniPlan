defmodule JourniPlan.Itineraries.Events.JournalEntryBodyUpdated do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :body
  ]
end
