defmodule JourniPlan.Repo.Migrations.CreateActivityTable do
  use Ecto.Migration

  def change do
    create table(:activities, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :name, :string
      add :description, :string
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :itinerary_id, references(:itineraries, type: :uuid, column: :uuid)
      add :user_id, references(:users)

      timestamps(type: :naive_datetime_usec)
    end
  end
end
