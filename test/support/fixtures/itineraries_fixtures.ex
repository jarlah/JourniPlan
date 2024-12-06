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
        "description" => "some description",
        "name" => "some name",
        "user_id" => user_id
      })
      |> JourniPlan.Itineraries.create_itinerary()

    itinerary
    |> JourniPlan.Repo.preload([:activities, :journal_entries])
  end

  def activity_fixture(attrs \\ %{}) do
    user_id = attrs[:user_id] || AccountsFixtures.user_fixture().id
    itinerary_id = attrs[:itinerary_id] || itinerary_fixture(%{"user_id" => user_id}).uuid

    {:ok, actitivity} =
      attrs
      |> Enum.into(%{
        "name" => "some name",
        "description" => "some description",
        "end_time" => "2021-01-01T12:00",
        "start_time" => "2021-01-01T16:00",
        "user_id" => user_id,
        "itinerary_uuid" => itinerary_id
      })
      |> JourniPlan.Itineraries.create_activity()

    actitivity
    |> JourniPlan.Repo.preload(:itinerary)
  end

  def journal_entry_fixture(attrs \\ %{}) do
    user_id = attrs[:user_id] || AccountsFixtures.user_fixture().id
    itinerary_id = attrs[:itinerary_id] || itinerary_fixture(%{"user_id" => user_id}).uuid

    activity_id =
      attrs[:activity_id] ||
        activity_fixture(%{"user_id" => user_id, "itinerary_id" => itinerary_id}).uuid

    {:ok, journal_entry} =
      attrs
      |> Enum.into(%{
        "body" => "some body",
        "title" => "some title",
        "user_id" => user_id,
        "entry_date" => "2021-01-01T00:00",
        "itinerary_uuid" => itinerary_id,
        "activity_uuid" => activity_id
      })
      |> JourniPlan.Itineraries.create_journal_entry()

    journal_entry
  end
end
