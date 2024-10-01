defmodule JourniPlan.ItinerariesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `JourniPlan.Itineraries` context.
  """

  alias JourniPlan.AccountsFixtures

  @doc """
  Generate a itinerary.
  """
  def itinerary_fixture(attrs \\ %{}) do
    user_id = attrs[:user_id] || AccountsFixtures.user_fixture().id

    {:ok, itinerary} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        user_id: user_id
      })
      |> JourniPlan.Itineraries.create_itinerary()

    itinerary
  end

  def activity_fixture(attrs \\ %{}) do
    user_id = attrs[:user_id] || AccountsFixtures.user_fixture().id
    itinerary_id = attrs[:itinerary_id] || itinerary_fixture(%{user_id: user_id}).uuid

    {:ok, actitivity} =
      attrs
      |> Enum.into(%{
        name: "some name",
        description: "some description",
        end_time: ~U[2021-01-01 12:00:00Z],
        start_time: ~U[2021-01-01 16:00:00Z],
        user_id: user_id,
        itinerary_uuid: itinerary_id
      })
      |> JourniPlan.Itineraries.create_activity()

    actitivity
  end

  def journal_entry_fixture(attrs \\ %{}) do
    user_id = attrs[:user_id] || AccountsFixtures.user_fixture().id
    itinerary_id = attrs[:itinerary_id] || itinerary_fixture(%{user_id: user_id}).uuid
    activity_id = attrs[:activity_id] || activity_fixture(%{user_id: user_id, itinerary_id: itinerary_id}).uuid

    {:ok, journal_entry} =
      attrs
      |> Enum.into(%{
        body: "some body",
        title: "some title",
        user_id: user_id,
        entry_date: ~U[2021-01-01 00:00:00Z],
        itinerary_uuid: itinerary_id,
        activity_uuid: activity_id
      })
      |> JourniPlan.Itineraries.create_journal_entry()

    journal_entry
  end
end
