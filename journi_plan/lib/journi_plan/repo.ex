defmodule JourniPlan.Repo do
  use Ecto.Repo,
    otp_app: :journi_plan,
    adapter: Ecto.Adapters.Postgres
end
