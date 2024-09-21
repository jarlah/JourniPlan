defmodule JourniPlan.Itineraries.Commands.UpdateItinerary do
  defstruct [
    :uuid,
    :name,
    :description
  ]

  use ExConstructor

  @types %{uuid: :uuid, name: :string, description: :string}

  @doc false
  def changeset(command, params) do
    {command, @types}
    |> Ecto.Changeset.cast(params, [:uuid, :name, :description])
    |> Ecto.Changeset.validate_required([:uuid, :name, :description])
  end

  def assign_uuid(%__MODULE__{} = update, uuid) do
    %__MODULE__{update | uuid: uuid}
  end
end
