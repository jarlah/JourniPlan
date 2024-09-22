defmodule JourniPlan.Itineraries.Events.ActivityDescriptionUpdated do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :description
  ]
end
