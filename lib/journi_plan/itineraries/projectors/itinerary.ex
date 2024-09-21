defmodule JourniPlan.Itineraries.Projectors.Itinerary do
  use Commanded.Projections.Ecto,
    name: "Itineraries.Projectors.Itinerary",
    application: JourniPlan.App,
    repo: JourniPlan.Repo,
    consistency: :strong

  alias JourniPlan.Repo

  alias JourniPlan.Itineraries.Events.ItineraryCreated
  alias JourniPlan.Itineraries.Events.ItineraryNameUpdated
  alias JourniPlan.Itineraries.Events.ItineraryDescriptionUpdated

  alias JourniPlan.Itineraries.Projections.Itinerary

  project(%ItineraryCreated{} = created, _, fn multi ->
    Ecto.Multi.insert(multi, :todo, %Itinerary{
      uuid: created.uuid,
      name: created.name,
      description: created.description
    })
  end)

  project(%ItineraryNameUpdated{uuid: uuid, name: name}, _, fn multi ->
    case Repo.get(Itinerary, uuid) do
      nil -> multi
      itinerary -> Ecto.Multi.update(multi, :itinerary, Itinerary.changeset(itinerary, %{name: name}))
    end
  end)

  project(%ItineraryDescriptionUpdated{uuid: uuid, description: description}, _, fn multi ->
    case Repo.get(Itinerary, uuid) do
      nil -> multi
      itinerary -> Ecto.Multi.update(multi, :itinerary, Itinerary.changeset(itinerary, %{description: description}))
    end
  end)

end
