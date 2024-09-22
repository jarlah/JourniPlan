defmodule JourniPlan.Itineraries.Events.ActivityNameUpdated do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :name
  ]
end
