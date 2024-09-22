defmodule JourniPlan.Itineraries.Commands.CreateActivity do
  defstruct [
    :uuid,
    :name,
    :description,
    :start_time,
    :end_time,
    :itinerary_id,
    :activity_id,
    :user_id
  ]

  use ExConstructor

  @types %{
    name: :string,
    description: :string,
    start_time: :utc_datetime,
    end_time: :utc_datetime,
    itinerary_id: :binary_id,
    activity_id: :binary_id,
    user_id: :integer
  }

  @doc false
  def changeset(command, params \\ %{}) do
    {command, @types}
    |> Ecto.Changeset.cast(params, [:name, :description, :start_time, :end_time, :itinerary_id, :activity_id, :user_id])
    |> Ecto.Changeset.validate_required([:name, :description, :start_time, :end_time, :itinerary_id, :activity_id, :user_id])
  end

  def assign_uuid(%__MODULE__{} = create, uuid) do
    %__MODULE__{create | uuid: uuid}
  end
end
