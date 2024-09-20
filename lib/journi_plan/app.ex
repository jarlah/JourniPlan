defmodule JourniPlan.App do
  use Commanded.Application, otp_app: :journi_plan

  router(JourniPlan.Router)
end
