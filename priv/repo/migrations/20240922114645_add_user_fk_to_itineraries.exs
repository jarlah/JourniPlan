defmodule JourniPlan.Repo.Migrations.AddUserFkToItineraries do
  use Ecto.Migration

  def change do
    alter table(:itineraries) do
      add :user_id, references(:users), null: false
    end
  end
end
