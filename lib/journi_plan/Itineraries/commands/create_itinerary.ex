defmodule JourniPlan.Itineraries.Commands.CreateItinerary do
  defstruct [
    :uuid,
    :name,
    :description
  ]

  @doc false
  def changeset(command, params) do
    command
    |> Ecto.Changeset.cast(params, [:uuid, :name, :description])
    |> Ecto.Changeset.validate_required([:uuid, :name, :description])
  end
end
