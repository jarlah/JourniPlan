defmodule JourniPlan.Itineraries.Commands.CreateItinerary do
  defstruct [
    :uuid,
    :name,
    :description
  ]

  def changeset(%__MODULE__{} = command, params) do
    {command, params}
    |> Ecto.Changeset.cast(params, [:uuid, :name, :description])
    |> Ecto.Changeset.validate_required([:uuid, :name, :description])
  end
end
