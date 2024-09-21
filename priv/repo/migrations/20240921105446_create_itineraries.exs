defmodule JourniPlan.Repo.Migrations.CreateItineraries do
  use Ecto.Migration

  def change do
    create table(:itineraries) do
      add :name, :string
      add :description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
