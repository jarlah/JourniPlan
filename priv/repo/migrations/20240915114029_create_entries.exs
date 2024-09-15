defmodule JourniPlan.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :title, :string
      add :body, :text
      add :journal_id, references(:journals, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:entries, [:journal_id])
  end
end
