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
      {:ok, updated_itinerary} = Itineraries.update_itinerary(itinerary, %{name: "Updated name", description: "Updated desc"})
      assert updated_itinerary == Itineraries.get_itinerary!(itinerary.uuid)
    end
  end

  describe "itineraries" do
    alias JourniPlan.Itineraries.Projections.Itinerary

    import JourniPlan.ItinerariesFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_itineraries/0 returns all itineraries" do
      itinerary = itinerary_fixture()
      assert Itineraries.list_itineraries() == [itinerary]
    end

    test "get_itinerary!/1 returns the itinerary with given id" do
      itinerary = itinerary_fixture()
      assert Itineraries.get_itinerary!(itinerary.uuid) == itinerary
    end

    test "create_itinerary/1 with valid data creates a itinerary" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Itinerary{} = itinerary} = Itineraries.create_itinerary(valid_attrs)
      assert itinerary.description == "some description"
      assert itinerary.name == "some name"
    end

    test "create_itinerary/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Itineraries.create_itinerary(@invalid_attrs)
    end

    test "update_itinerary/2 with valid data updates the itinerary" do
      itinerary = itinerary_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Itinerary{} = itinerary} = Itineraries.update_itinerary(itinerary, update_attrs)
      assert itinerary.description == "some updated description"
      assert itinerary.name == "some updated name"
    end

    test "update_itinerary/2 with invalid data returns error changeset" do
      itinerary = itinerary_fixture()
      assert {:error, %Ecto.Changeset{}} = Itineraries.update_itinerary(itinerary, @invalid_attrs)
      assert itinerary == Itineraries.get_itinerary!(itinerary.uuid)
    end

    test "delete_itinerary/1 deletes the itinerary" do
      itinerary = itinerary_fixture()
      assert {:ok, %Itinerary{}} = Itineraries.delete_itinerary(itinerary)
      assert_raise Ecto.NoResultsError, fn -> Itineraries.get_itinerary!(itinerary.uuid) end
    end
  end
end
