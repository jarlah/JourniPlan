defmodule JourniPlan.Itineraries.Projections.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @derive {Phoenix.Param, key: :uuid}

  schema "activities" do
    field :name, :string
    field :description, :string
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    belongs_to :itinerary, JourniPlan.Itineraries.Projections.Itinerary, references: :uuid
    belongs_to :user, JourniPlan.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:name, :description, :start_time, :end_time])
  end
end