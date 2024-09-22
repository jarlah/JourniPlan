defmodule JourniPlan.Itineraries.Commands.UpdateActivity do
  defstruct [
    :uuid,
    :name,
    :description,
    :start_time,
    :end_time
  ]

  use ExConstructor

  @types %{
    name: :string,
    description: :string,
    start_time: :utc_datetime,
    end_time: :utc_datetime
  }

  @doc false
  def changeset(command, params \\ %{}) do
    {command, @types}
    |> Ecto.Changeset.cast(params, [:name, :description, :start_time, :end_time])
    |> Ecto.Changeset.validate_required([:name, :description, :start_time, :end_time])
  end

  def assign_uuid(%__MODULE__{} = update, uuid) do
    %__MODULE__{update | uuid: uuid}
  end
end
