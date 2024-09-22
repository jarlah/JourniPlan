defmodule JourniPlan.Router do
  use Commanded.Commands.Router

  alias JourniPlan.Itineraries.Aggregates.Itinerary
  alias JourniPlan.Itineraries.Commands.DeleteItinerary
  alias JourniPlan.Itineraries.Commands.CreateItinerary
  alias JourniPlan.Itineraries.Commands.UpdateItinerary

  dispatch([CreateItinerary], to: Itinerary, identity: :uuid)
  dispatch([UpdateItinerary], to: Itinerary, identity: :uuid)
  dispatch([DeleteItinerary], to: Itinerary, identity: :uuid)

  alias JourniPlan.Itineraries.Aggregates.JournalEntry
  alias JourniPlan.Itineraries.Commands.CreateJournalEntry
  alias JourniPlan.Itineraries.Commands.UpdateJournalEntry
  alias JourniPlan.Itineraries.Commands.DeleteJournalEntry

  dispatch([CreateJournalEntry], to: JournalEntry, identity: :uuid)
  dispatch([UpdateJournalEntry], to: JournalEntry, identity: :uuid)
  dispatch([DeleteJournalEntry], to: JournalEntry, identity: :uuid)

  alias JourniPlan.Itineraries.Aggregates.Activity
  alias JourniPlan.Itineraries.Commands.CreateActivity
  alias JourniPlan.Itineraries.Commands.UpdateActivity
  alias JourniPlan.Itineraries.Commands.DeleteActivity

  dispatch([CreateActivity], to: Activity, identity: :uuid)
  dispatch([UpdateActivity], to: Activity, identity: :uuid)
  dispatch([DeleteActivity], to: Activity, identity: :uuid)
end
