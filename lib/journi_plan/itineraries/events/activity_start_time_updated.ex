defmodule JourniPlan.Itineraries.Events.ActivityStartTimeUpdated do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :start_time
  ]
end
