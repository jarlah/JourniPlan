defmodule JourniPlan.Itineraries.JournalEntry do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @derive {Phoenix.Param, key: :uuid}

  schema "journal_entries" do
    field :body, :string
    field :entry_date, :utc_datetime
    field :title, :string

    belongs_to :activity, JourniPlan.Itineraries.Projections.Activity,
      references: :uuid,
      foreign_key: :activity_uuid,
      type: :binary_id

    belongs_to :itinerary, JourniPlan.Itineraries.Projections.Itinerary,
      references: :uuid,
      foreign_key: :itinerary_uuid,
      type: :binary_id

    belongs_to :user, JourniPlan.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(journal_entry, attrs) do
    journal_entry
    |> cast(attrs, [:title, :body, :entry_date])
  end
end
