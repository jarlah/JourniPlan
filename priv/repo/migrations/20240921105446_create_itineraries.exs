defmodule JourniPlan.Repo.Migrations.CreateItineraries do
  use Ecto.Migration

  def change do
    create table(:itineraries, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :name, :string
      add :description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
