defmodule JourniPlan.ItinerariesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `JourniPlan.Itineraries` context.
  """

  @doc """
  Generate a itinerary.
  """
  def itinerary_fixture(attrs \\ %{}) do
    {:ok, itinerary} =
      attrs
      |> Enum.into(%{
        description: "some description",
        end_date: ~D[2024-09-18],
        start_date: ~D[2024-09-18],
        title: "some title"
      })
      |> JourniPlan.Itineraries.create_itinerary()

    itinerary
  end
end