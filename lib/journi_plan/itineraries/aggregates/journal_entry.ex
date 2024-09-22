defmodule JourniPlan.Itineraries.Aggregates.JournalEntry do
  defstruct [
    :uuid,
    :title,
    :body,
    :itinerary_id,
    :activity_id,
    :entry_date,
    :user_id
  ]

  alias JourniPlan.Itineraries.Commands.CreateJournalEntry
  alias JourniPlan.Itineraries.Commands.UpdateJournalEntry
  alias JourniPlan.Itineraries.Events.JournalEntryCreated
  alias JourniPlan.Itineraries.Events.JournalEntryTitleUpdated
  alias JourniPlan.Itineraries.Events.JournalEntryBodyUpdated
  alias JourniPlan.Itineraries.Events.JournalEntryDeleted

  alias JourniPlan.Itineraries.Aggregates.JournalEntry

  def execute(%JournalEntry{uuid: nil}, %CreateJournalEntry{} = event) do
    %JournalEntryCreated{
      uuid: event.uuid,
      title: event.title,
      body: event.body,
      entry_date: event.entry_date,
      itinerary_id: event.itinerary_id,
      activity_id: event.activity_id,
      user_id: event.user_id
    }
  end

  def execute(%JournalEntry{} = journal_entry, %UpdateJournalEntry{} = event) do
    title_command =
      if journal_entry.title != event.title and not is_nil(event.title),
        do: %JournalEntryTitleUpdated{uuid: journal_entry.uuid, title: event.title}

    body_command =
      if journal_entry.body != event.body and not is_nil(event.body),
        do: %JournalEntryBodyUpdated{uuid: journal_entry.uuid, body: event.body}

    [title_command, body_command] |> Enum.filter(&Function.identity/1)
  end

  def apply(%JournalEntry{} = journal_entry, %JournalEntryTitleUpdated{} = event) do
    %JournalEntry{journal_entry | title: event.title}
  end

  def apply(%JournalEntry{} = journal_entry, %JournalEntryBodyUpdated{} = event) do
    %JournalEntry{journal_entry | body: event.body}
  end

  def apply(%JournalEntry{}, %JournalEntryDeleted{}) do
    nil
  end
end