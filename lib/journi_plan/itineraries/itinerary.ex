defmodule JourniPlan.Itineraries.Itinerary do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @derive {Phoenix.Param, key: :uuid}

  schema "itineraries" do
    field :description, :string
    field :name, :string

    has_many :activities, JourniPlan.Itineraries.Activity, foreign_key: :itinerary_uuid

    has_many :journal_entries, JourniPlan.Itineraries.JournalEntry, foreign_key: :itinerary_uuid

    belongs_to :user, JourniPlan.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(itinerary, attrs \\ %{}) do
    itinerary
    |> cast(attrs, [:uuid, :user_id, :name, :description])
    |> validate_required([:user_id, :name, :description])
  end
end
