defmodule JourniPlan.Itineraries.Commands.CreateJournalEntry do
  defstruct [
    :uuid,
    :title,
    :body,
    :entry_date,
    :activity_id,
    :itinerary_id,
    :user_id
  ]

  use ExConstructor

  @types %{
    title: :string,
    body: :string,
    entry_date: :utc_datetime,
    activity_id: :binary_id,
    itinerary_id: :binary_id,
    user_id: :integer
  }

  @doc false
  def changeset(command, params \\ %{}) do
    {command, @types}
    |> Ecto.Changeset.cast(params, [:title, :body, :entry_date, :activity_id, :itinerary_id, :user_id])
    |> Ecto.Changeset.validate_required([:title, :body, :entry_date, :itinerary_id, :user_id])
  end

  def assign_uuid(%__MODULE__{} = create, uuid) do
    %__MODULE__{create | uuid: uuid}
  end
end
