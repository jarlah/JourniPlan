defmodule JourniPlan.ItinerariesTest do
  use JourniPlan.DataCase

  alias JourniPlan.Itineraries

  describe "commands should generate events and be projected" do
    test "create itinerary" do
      {:ok, itinerary} = Itineraries.create_itinerary(%{name: "Test", description: "test"})
      assert itinerary == Itineraries.get_itinerary!(itinerary.uuid)
    end

    test "update itinerary" do
      {:ok, itinerary} = Itineraries.create_itinerary(%{name: "Test", description: "test"})
      {:ok, updated_itinerary} = Itineraries.update_itinerary(itinerary, %{description: "Updated desc"})
      assert updated_itinerary == Itineraries.get_itinerary!(itinerary.uuid)
    end
  end
end
