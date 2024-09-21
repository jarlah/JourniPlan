defmodule JourniPlan.Itineraries.Commands.UpdateItinerary do
  defstruct [
    :uuid,
    :name,
    :description
  ]

  @types %{uuid: :uuid, name: :string, description: :string}

  @doc false
  def changeset(command, params) do
    {command, @types}
    |> Ecto.Changeset.cast(params, [:uuid, :name, :description])
    |> Ecto.Changeset.validate_required([:uuid, :name, :description])
  end
end
