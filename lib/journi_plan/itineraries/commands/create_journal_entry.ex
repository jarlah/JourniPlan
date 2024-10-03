defmodule JourniPlan.Itineraries.Commands.CreateJournalEntry do
  defstruct [
    :uuid,
    :title,
    :body,
    :entry_date,
    :activity_uuid,
    :itinerary_uuid,
    :user_id
  ]

  use ExConstructor
  alias Ecto.Changeset
  alias JourniPlan.Itineraries.Projections.Itinerary
  alias JourniPlan.Itineraries.Projections.Activity
  alias JourniPlan.Accounts.User
  import JourniPlan.Utils.Changeset

  @types %{
    title: :string,
    body: :string,
    entry_date: :utc_datetime,
    activity_uuid: :binary_id,
    itinerary_uuid: :binary_id,
    user_id: :integer
  }

  @doc false
  def changeset(command, params \\ %{}) do
    {command, @types}
    |> Changeset.cast(params, [
      :title,
      :body,
      :entry_date,
      :activity_uuid,
      :itinerary_uuid,
      :user_id
    ])
    |> Changeset.validate_required([:title, :body, :entry_date, :itinerary_uuid, :user_id])
    |> foreign_key_exists(Activity, :uuid, :activity_uuid)
    |> foreign_key_exists(Itinerary, :uuid, :itinerary_uuid)
    |> foreign_key_exists(User, :id, :user_id)
  end

  def assign_uuid(%__MODULE__{} = create, uuid) do
    %__MODULE__{create | uuid: uuid}
  end
end
