defmodule JourniPlan.Itineraries.Projections.Itinerary do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @derive {Phoenix.Param, key: :uuid}

  schema "itineraries" do
    field :description, :string
    field :name, :string
    belongs_to :user, JourniPlan.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(itinerary, attrs) do
    itinerary
    |> cast(attrs, [:name, :description])
  end
end
