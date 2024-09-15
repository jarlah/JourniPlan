defmodule JourniPlan.Journals.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :title, :string
    field :body, :string
    belongs_to :journal, JourniPlan.Journals.Journal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:title, :body, :journal_id])
    |> validate_required([:title, :body, :journal_id])
  end
end
