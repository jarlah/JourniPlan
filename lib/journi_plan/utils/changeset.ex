defmodule JourniPlan.Utils.Changeset do
  alias Ecto.Changeset
  alias JourniPlan.Repo
  import Ecto.Query, only: [from: 2]

  def foreign_key_exists(changes, projection, projection_id_col, field) do
    foreign_key = Changeset.get_field(changes, field)
    case foreign_key do
      nil ->
        changes
      _ ->
        valid = Repo.exists?(from p in projection, where: field(p, ^projection_id_col) == ^foreign_key)
        case valid do
          false -> Changeset.add_error(changes, field, "should exist")
          true -> changes
        end
    end
  end
end
