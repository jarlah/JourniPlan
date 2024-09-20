defmodule JourniPlan.Itineraries.Aggregates.Itinerary do
  defstruct [
    :uuid,
    :name,
    :description
  ]

  alias JourniPlan.Itineraries.Aggregates.Itinerary
  alias JourniPlan.Itineraries.Commands.CreateItinerary
  alias JourniPlan.Itineraries.Events.ItineraryCreated

  def execute(%Itinerary{uuid: nil}, %CreateItinerary{} = create) do
    %ItineraryCreated{
      uuid: create.uuid,
      name: create.name,
      description: create.description
    }
  end

  def apply(%Itinerary{} = todo, %ItineraryCreated{} = created) do
    %Itinerary{
      todo
      | uuid: created.uuid,
        name: created.name,
        description: created.description
    }
  end
end
