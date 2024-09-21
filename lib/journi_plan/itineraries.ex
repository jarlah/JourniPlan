defmodule JourniPlan.Itineraries do

  import Ecto.Query, warn: false
  alias JourniPlan.App
  alias JourniPlan.Repo
  alias JourniPlan.Itineraries.Commands.{CreateItinerary, UpdateItinerary}
  alias JourniPlan.Itineraries.Projections.Itinerary

  def list_itineraries do
    Repo.all(Itinerary)
  end

  def get_itinerary!(uuid) do
    Repo.get_by!(Itinerary, uuid: uuid)
  end

  def create_itinerary(attrs \\ %{}) do
    uuid = Ecto.UUID.generate()

    command =
      attrs
      |> CreateItinerary.new()
      |> CreateItinerary.assign_uuid(uuid)

    with :ok <- App.dispatch(command, consistency: :strong) do
      {:ok, get_itinerary!(uuid)}
    else
      reply -> reply
    end
  end

  def update_itinerary(%Itinerary{uuid: uuid}, attrs) do
    # TODO: ensure todo is active
    command =
      attrs
      |> UpdateItinerary.new()
      |> UpdateItinerary.assign_uuid(uuid)

    with :ok <- App.dispatch(command, consistency: :strong) do
      {:ok, get_itinerary!(uuid)}
    else
      reply -> reply
    end
  end
end
