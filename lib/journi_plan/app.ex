defmodule JourniPlan.App do
  use Commanded.Application,
    otp_app: :journi_plan,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: JourniPlan.EventStore
    ]

  router(JourniPlan.Router)
end
