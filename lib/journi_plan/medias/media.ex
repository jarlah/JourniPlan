defmodule JourniPlan.Medias.Media do
  use Ecto.Schema
  import Ecto.Changeset

  schema "medias" do
    field :name, :string
    field :media_type, :string
    field :media_url, :string
    field :entry_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(media, attrs) do
    media
    |> cast(attrs, [:name, :media_type, :media_url])
    |> validate_required([:name, :media_type, :media_url])
  end
end
