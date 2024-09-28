defmodule JourniPlan.Utils.UUID do
  def cast_uuid!(uuid) do
    if uuid == nil do
      nil
    else
      case Ecto.UUID.cast(uuid) do
        {:ok, casted_uuid} -> casted_uuid
        :error -> raise ArgumentError, "Invalid UUID: #{uuid}"
      end
    end
  end
end
