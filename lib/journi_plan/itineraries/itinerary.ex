defmodule JourniPlan.Itineraries.Itinerary do
  use Ecto.Schema
  import Ecto.Changeset

  schema "itineraries" do
    field :description, :string
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(itinerary, attrs) do
    itinerary
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
