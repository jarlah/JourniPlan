defmodule JourniPlan.Itineraries.Projectors.Activity do
  use Commanded.Projections.Ecto,
    name: "Itineraries.Projectors.Activity",
    application: JourniPlan.App,
    repo: JourniPlan.Repo,
    consistency: :strong

  alias JourniPlan.Repo

  import JourniPlan.Utils.UUID

  alias JourniPlan.Itineraries.Events.{
    ActivityCreated,
    ActivityNameUpdated,
    ActivityDescriptionUpdated,
    ActivityStartTimeUpdated,
    ActivityEndTimeUpdated,
    ActivityDeleted
  }

  alias JourniPlan.Itineraries.Projections.Activity

  import JourniPlan.TimexUtils, only: [parse_to_datetime!: 1]

  project(%ActivityCreated{} = created, _, fn multi ->
    start_time = parse_to_datetime!(created.start_time)
    end_time = parse_to_datetime!(created.end_time)
    itinerary_uuid = cast_uuid!(created.itinerary_uuid)

    Ecto.Multi.insert(multi, :activity, %Activity{
      uuid: created.uuid,
      name: created.name,
      description: created.description,
      start_time: start_time,
      end_time: end_time,
      itinerary_uuid: itinerary_uuid,
      user_id: created.user_id
    })
  end)

  project(%ActivityNameUpdated{uuid: uuid, name: name}, _, fn multi ->
    case Repo.get(Activity, uuid) do
      nil -> multi
      activity -> Ecto.Multi.update(multi, :activity, Activity.changeset(activity, %{name: name}))
    end
  end)

  project(%ActivityDescriptionUpdated{uuid: uuid, description: description}, _, fn multi ->
    case Repo.get(Activity, uuid) do
      nil ->
        multi

      activity ->
        Ecto.Multi.update(
          multi,
          :activity,
          Activity.changeset(activity, %{description: description})
        )
    end
  end)

  project(%ActivityStartTimeUpdated{uuid: uuid, start_time: start_time}, _, fn multi ->
    case Repo.get(Activity, uuid) do
      nil ->
        multi

      activity ->
        Ecto.Multi.update(
          multi,
          :activity,
          Activity.changeset(activity, %{start_time: start_time})
        )
    end
  end)

  project(%ActivityEndTimeUpdated{uuid: uuid, end_time: end_time}, _, fn multi ->
    case Repo.get(Activity, uuid) do
      nil ->
        multi

      activity ->
        Ecto.Multi.update(multi, :activity, Activity.changeset(activity, %{end_time: end_time}))
    end
  end)

  project(%ActivityDeleted{uuid: uuid}, _, fn multi ->
    case Repo.get(Activity, uuid) do
      nil -> multi
      activity -> Ecto.Multi.delete(multi, :activity, activity)
    end
  end)
end
