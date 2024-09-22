# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     JourniPlan.Repo.insert!(%JourniPlan.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, user} = JourniPlan.Accounts.register_user(%{ email: "admin@localhost", password: "superpassword123" })

{:ok, itinerary} = JourniPlan.Itineraries.create_itinerary(%{
  name: "My first itinerary",
  description: "This is my first itinerary",
  user_id: user.id
})

{:ok, activity} = JourniPlan.Itineraries.create_activity(%{
  name: "My first activity",
  description: "This is my first activity",
  start_time: ~U[2024-09-22 12:34:56Z],
  end_time: ~U[2024-09-26 15:00:56Z],
  itinerary_id: itinerary.uuid,
  user_id: user.id
})

{:ok, _journal_entry} = JourniPlan.Itineraries.create_journal_entry(%{
  title: "My first journal entry",
  body: "This is my first journal entry",
  entry_date: ~U[2024-09-24 12:34:56Z],
  itinerary_id: itinerary.uuid,
  activity_id: activity.uuid,
  user_id: user.id
})
