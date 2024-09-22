defmodule JourniPlan.Itineraries.Events.ActivityEndTimeUpdated do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :end_time
  ]
end
