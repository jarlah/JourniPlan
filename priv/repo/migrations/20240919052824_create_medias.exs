defmodule JourniPlan.Repo.Migrations.CreateMedias do
  use Ecto.Migration

  def change do
    create table(:medias) do
      add :name, :string
      add :media_type, :string
      add :media_url, :text
      add :entry_id, references(:entries, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:medias, [:entry_id])
  end
end
