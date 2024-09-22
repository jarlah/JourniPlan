defmodule JourniPlan.Itineraries.Commands.UpdateJournalEntry do
  defstruct [
    :uuid,
    :title,
    :body,
    :entry_date
  ]

  use ExConstructor

  @types %{
    title: :string,
    body: :string,
    entry_date: :utc_datetime
  }

  @doc false
  def changeset(command, params \\ %{}) do
    {command, @types}
    |> Ecto.Changeset.cast(params, [:title, :body, :entry_date])
    |> Ecto.Changeset.validate_required([:title, :body, :entry_date])
  end

  def assign_uuid(%__MODULE__{} = update, uuid) do
    %__MODULE__{update | uuid: uuid}
  end
end
