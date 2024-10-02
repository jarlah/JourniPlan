defmodule JourniPlan.Itineraries.Projectors.JournalEntry do
  use Commanded.Projections.Ecto,
    name: "Itineraries.Projectors.JournalEntry",
    application: JourniPlan.App,
    repo: JourniPlan.Repo,
    consistency: :strong

  alias JourniPlan.Repo

  import  JourniPlan.Utils.UUID

  alias JourniPlan.Itineraries.Events.JournalEntryCreated
  alias JourniPlan.Itineraries.Events.JournalEntryTitleUpdated
  alias JourniPlan.Itineraries.Events.JournalEntryBodyUpdated
  alias JourniPlan.Itineraries.Events.JournalEntryDeleted

  alias JourniPlan.Itineraries.Projections.JournalEntry

  project(%JournalEntryCreated{} = created, _, fn multi ->
    entry_date =
      created.entry_date
      |> Timex.parse!("%Y-%m-%dT%H:%M", :strftime)
      |> Timex.to_datetime("Etc/UTC")
    itinerary_uuid = cast_uuid!(created.itinerary_uuid)
    activity_uuid = cast_uuid!(created.activity_uuid)

    Ecto.Multi.insert(multi, :journal_entry, %JournalEntry{
      uuid: created.uuid,
      title: created.title,
      body: created.body,
      user_id: created.user_id,
      entry_date: entry_date,
      itinerary_uuid: itinerary_uuid,
      activity_uuid: activity_uuid
    })
  end)

  project(%JournalEntryTitleUpdated{uuid: uuid, title: title}, _, fn multi ->
    case Repo.get(JournalEntry, uuid) do
      nil -> multi
      journal_entry -> Ecto.Multi.update(multi, :journal_entry, JournalEntry.changeset(journal_entry, %{title: title}))
    end
  end)

  project(%JournalEntryBodyUpdated{uuid: uuid, body: body}, _, fn multi ->
    case Repo.get(JournalEntry, uuid) do
      nil -> multi
      journal_entry -> Ecto.Multi.update(multi, :journal_entry, JournalEntry.changeset(journal_entry, %{body: body}))
    end
  end)

  project(%JournalEntryDeleted{uuid: uuid}, _, fn multi ->
    case Repo.get(JournalEntry, uuid) do
      nil -> multi
      journal_entry -> Ecto.Multi.delete(multi, :journal_entry, journal_entry)
    end
  end)
end
