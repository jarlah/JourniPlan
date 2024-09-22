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
    user = AccountsFixtures.user_fixture()

    {:ok, itinerary} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        user_id: user.id
      })
      |> JourniPlan.Itineraries.create_itinerary()

    itinerary
  end
end
