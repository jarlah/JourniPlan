defmodule JourniPlan.Repo.Migrations.CreateItineraries do
  use Ecto.Migration

  def change do
    create table(:itineraries) do
      add :title, :string
      add :description, :text
      add :start_date, :date
      add :end_date, :date
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:itineraries, [:user_id])
  end
end
