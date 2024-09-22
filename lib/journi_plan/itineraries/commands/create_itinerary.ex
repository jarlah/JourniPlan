defmodule JourniPlan.Itineraries.Commands.CreateItinerary do
  defstruct [
    :uuid,
    :name,
    :description,
    :user_id
  ]

  use ExConstructor

  @types %{name: :string, description: :string, user_id: :integer}

  @doc false
  def changeset(command, params \\ %{}) do
    {command, @types}
    |> Ecto.Changeset.cast(params, [:name, :description, :user_id])
    |> Ecto.Changeset.validate_required([:name, :description, :user_id])
  end

  def assign_uuid(%__MODULE__{} = create, uuid) do
    %__MODULE__{create | uuid: uuid}
  end
end
