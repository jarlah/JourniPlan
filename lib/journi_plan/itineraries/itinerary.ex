defmodule JourniPlan.Itineraries.Itinerary do
  use Ecto.Schema
  import Ecto.Changeset

  schema "itineraries" do
    field :description, :string
    field :title, :string
    field :start_date, :date
    field :end_date, :date
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(itinerary, attrs) do
    itinerary
    |> cast(attrs, [:title, :description, :start_date, :end_date])
    |> validate_required([:title, :description, :start_date, :end_date])
  end
end
