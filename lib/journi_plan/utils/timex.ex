defmodule JourniPlan.TimexUtils do
  def parse_to_datetime!(time) when is_binary(time) do
    time
      |> Timex.parse!("%Y-%m-%dT%H:%M", :strftime)
      |> Timex.to_datetime("Etc/UTC")
  end
end
