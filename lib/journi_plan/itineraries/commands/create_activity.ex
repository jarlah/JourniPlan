defmodule JourniPlan.Itineraries.Commands.CreateActivity do
  defstruct [
    :uuid,
    :name,
    :description,
    :start_time,
    :end_time,
    :itinerary_uuid,
    :user_id
  ]

  use ExConstructor
  alias Ecto.Changeset
  alias JourniPlan.Itineraries.Projections.Itinerary
  alias JourniPlan.Accounts.User
  import JourniPlan.Utils.Changeset

  @types %{
    name: :string,
    description: :string,
    start_time: :utc_datetime,
    end_time: :utc_datetime,
    itinerary_uuid: :binary_id,
    user_id: :integer
  }

  @doc false
  def changeset(command, params \\ %{}) do
    {command, @types}
    |> Changeset.cast(params, [:name, :description, :start_time, :end_time, :itinerary_uuid, :user_id])
    |> Changeset.validate_required([:name, :description, :start_time, :end_time, :itinerary_uuid, :user_id])
    |> foreign_key_exists(Itinerary, :uuid, :itinerary_uuid)
    |> foreign_key_exists(User, :id, :user_id)
  end

  def assign_uuid(%__MODULE__{} = create, uuid) do
    %__MODULE__{create | uuid: uuid}
  end
end
