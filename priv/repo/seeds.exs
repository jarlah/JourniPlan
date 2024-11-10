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

import JourniPlan.TimexUtils, only: [parse_to_datetime!: 1]

{:ok, user} =
  JourniPlan.Accounts.register_user(%{email: "admin@localhost", password: "superpassword123"})

{:ok, itinerary} =
  %JourniPlan.Itineraries.Itinerary{
    uuid: Ecto.UUID.generate(),
    name: "My first itinerary",
    description: "This is my first itinerary",
    user_id: user.id
  } |> JourniPlan.Repo.insert

{:ok, activity} =
  %JourniPlan.Itineraries.Activity{
    uuid: Ecto.UUID.generate(),
    name: "My first activity",
    description: "This is my first activity",
    start_time: parse_to_datetime!("2024-09-22T12:34"),
    end_time: parse_to_datetime!("2024-09-26T15:00"),
    itinerary_uuid: itinerary.uuid,
    user_id: user.id
  } |> JourniPlan.Repo.insert

{:ok, _journal_entry} =
  %JourniPlan.Itineraries.JournalEntry{
    uuid: Ecto.UUID.generate(),
    title: "My first journal entry",
    body: "This is my first journal entry",
    entry_date: parse_to_datetime!("2024-09-24T12:34"),
    itinerary_uuid: itinerary.uuid,
    activity_uuid: activity.uuid,
    user_id: user.id
  } |> JourniPlan.Repo.insert
