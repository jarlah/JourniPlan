defmodule JourniPlan.Itineraries.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @derive {Phoenix.Param, key: :uuid}

  schema "activities" do
    field :name, :string
    field :description, :string
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    belongs_to :itinerary, JourniPlan.Itineraries.Itinerary,
      references: :uuid,
      foreign_key: :itinerary_uuid,
      type: :binary_id

    belongs_to :user, JourniPlan.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(activity, attrs \\ %{}) do
    activity
    |> cast(attrs, [:uuid, :user_id, :itinerary_uuid, :name, :description, :start_time, :end_time])
    |> validate_required([:user_id, :name, :description, :start_time, :end_time])
  end
end
