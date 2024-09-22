defmodule JourniPlan.Itineraries.Events.JournalEntryTitleUpdated do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :title
  ]
end
