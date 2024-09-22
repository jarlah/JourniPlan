defmodule JourniPlan.Itineraries.Aggregates.Itinerary do
  defstruct [
    :uuid,
    :name,
    :description,
    :user_id
  ]

  alias JourniPlan.Itineraries.Aggregates.Itinerary
  alias JourniPlan.Itineraries.Commands.CreateItinerary
  alias JourniPlan.Itineraries.Commands.UpdateItinerary
  alias JourniPlan.Itineraries.Commands.DeleteItinerary
  alias JourniPlan.Itineraries.Events.ItineraryCreated
  alias JourniPlan.Itineraries.Events.ItineraryNameUpdated
  alias JourniPlan.Itineraries.Events.ItineraryDescriptionUpdated
  alias JourniPlan.Itineraries.Events.ItineraryDeleted

  def execute(%Itinerary{uuid: nil}, %CreateItinerary{} = create) do
    %ItineraryCreated{
      uuid: create.uuid,
      name: create.name,
      description: create.description,
      user_id: create.user_id
    }
  end

  def execute(%Itinerary{} = itinerary, %UpdateItinerary{} = update) do
    name_command =
      if itinerary.name != update.name and not is_nil(update.name),
        do: %ItineraryNameUpdated{uuid: itinerary.uuid, name: update.name}

    description_command =
      if itinerary.description != update.description and not is_nil(update.description),
        do: %ItineraryDescriptionUpdated{uuid: itinerary.uuid, description: update.description}

    [name_command, description_command] |> Enum.filter(&Function.identity/1)
  end

  def execute(%Itinerary{}, %DeleteItinerary{uuid: uuid}) do
    %ItineraryDeleted{uuid: uuid}
  end

  def apply(%Itinerary{} = todo, %ItineraryCreated{} = created) do
    %Itinerary{
      todo
      | uuid: created.uuid,
        name: created.name,
        description: created.description
    }
  end

  def apply(%Itinerary{} = itinerary, %ItineraryNameUpdated{name: name}) do
    %Itinerary{itinerary | name: name}
  end

  def apply(%Itinerary{} = itinerary, %ItineraryDescriptionUpdated{description: description}) do
    %Itinerary{itinerary | description: description}
  end

  def apply(%Itinerary{}, %ItineraryDeleted{}) do
    nil
  end
end
