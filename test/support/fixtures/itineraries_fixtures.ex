defmodule JourniPlan.ItinerariesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `JourniPlan.Itineraries` context.
  """

  alias JourniPlan.Itineraries.Aggregates.Activity
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

  def activity_fixture(_attrs \\ %{}) do
    # TODO: Implement this function
    %Activity{
      description: "some description",
      end_time: ~U[2024-09-30 17:57:00Z],
      name: "some name",
      start_time: ~U[2024-09-30 17:57:00Z]
    }
  end

  def journal_entry_fixture(attrs \\ %{}) do
    user_id = attrs[:user_id] || AccountsFixtures.user_fixture().id
    itinerary_id = attrs[:itinerary_id] || itinerary_fixture(%{user_id: user_id}).uuid

    {:ok, journal_entry} =
      attrs
      |> Enum.into(%{
        body: "some body",
        title: "some title",
        user_id: user_id,
        entry_date: ~U[2021-01-01 00:00:00Z],
        itinerary_uuid: itinerary_id
      })
      |> JourniPlan.Itineraries.create_journal_entry()

    journal_entry
  end
end
