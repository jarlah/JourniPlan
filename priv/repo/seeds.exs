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

{:ok, user} =
  JourniPlan.Accounts.register_user(%{email: "admin@localhost", password: "superpassword123"})

{:ok, itinerary} =
  JourniPlan.Itineraries.create_itinerary(%{
    name: "My first itinerary",
    description: "This is my first itinerary",
    user_id: user.id
  })

{:ok, activity} =
  JourniPlan.Itineraries.create_activity(%{
    name: "My first activity",
    description: "This is my first activity",
    start_time: "2024-09-22T12:34",
    end_time: "2024-09-26T15:00",
    itinerary_uuid: itinerary.uuid,
    user_id: user.id
  })

{:ok, _journal_entry} =
  JourniPlan.Itineraries.create_journal_entry(%{
    title: "My first journal entry",
    body: "This is my first journal entry",
    entry_date: "2024-09-24T12:34",
    itinerary_uuid: itinerary.uuid,
    activity_uuid: activity.uuid,
    user_id: user.id
  })
