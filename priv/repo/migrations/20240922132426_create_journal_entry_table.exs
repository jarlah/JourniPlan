defmodule JourniPlan.Repo.Migrations.CreateJournalEntryTable do
  use Ecto.Migration

  def change do
    create table(:journal_entries, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :itinerary_uuid, references(:itineraries, type: :uuid, column: :uuid)
      add :activity_uuid, references(:activities, type: :uuid, column: :uuid)
      add :user_id, references(:users)
      add :title, :string
      add :body, :string
      add :entry_date, :utc_datetime

      timestamps(type: :naive_datetime_usec)
    end
  end
end
