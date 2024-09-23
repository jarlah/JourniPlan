defmodule JourniPlan.Itineraries.Commands.CreateItinerary do
  defstruct [
    :uuid,
    :name,
    :description,
    :user_id
  ]

  use ExConstructor
  alias Ecto.Changeset
  alias JourniPlan.Accounts.User
  import JourniPlan.Utils.Changeset

  @types %{name: :string, description: :string, user_id: :integer}

  @doc false
  def changeset(command, params \\ %{}) do
    {command, @types}
    |> Changeset.cast(params, [:name, :description, :user_id])
    |> Changeset.validate_required([:name, :description, :user_id])
    |> foreign_key_exists(User, :id, :user_id)
  end

  def assign_uuid(%__MODULE__{} = create, uuid) do
    %__MODULE__{create | uuid: uuid}
  end
end
