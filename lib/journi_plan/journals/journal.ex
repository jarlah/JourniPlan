defmodule JourniPlan.Journals.Journal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "journals" do
    field :title, :string
    field :description, :string
    field :is_public, :boolean, default: false
    belongs_to :user, JourniPlan.Accounts.User
    has_many :entries, JourniPlan.Journals.Entry

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(journal, attrs) do
    journal
    |> cast(attrs, [:title, :description, :is_public, :user_id])
    |> validate_required([:title, :description, :is_public, :user_id])
  end
end
