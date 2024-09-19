defmodule JourniPlan.ItinerariesTest do
  use JourniPlan.DataCase

  alias JourniPlan.Itineraries

  describe "itineraries" do
    alias JourniPlan.Itineraries.Itinerary

    import JourniPlan.ItinerariesFixtures

    @invalid_attrs %{description: nil, title: nil, start_date: nil, end_date: nil}

    test "list_itineraries/0 returns all itineraries" do
      itinerary = itinerary_fixture()
      assert Itineraries.list_itineraries() == [itinerary]
    end

    test "get_itinerary!/1 returns the itinerary with given id" do
      itinerary = itinerary_fixture()
      assert Itineraries.get_itinerary!(itinerary.id) == itinerary
    end

    test "create_itinerary/1 with valid data creates a itinerary" do
      valid_attrs = %{description: "some description", title: "some title", start_date: ~D[2024-09-18], end_date: ~D[2024-09-18]}

      assert {:ok, %Itinerary{} = itinerary} = Itineraries.create_itinerary(valid_attrs)
      assert itinerary.description == "some description"
      assert itinerary.title == "some title"
      assert itinerary.start_date == ~D[2024-09-18]
      assert itinerary.end_date == ~D[2024-09-18]
    end

    test "create_itinerary/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Itineraries.create_itinerary(@invalid_attrs)
    end

    test "update_itinerary/2 with valid data updates the itinerary" do
      itinerary = itinerary_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", start_date: ~D[2024-09-19], end_date: ~D[2024-09-19]}

      assert {:ok, %Itinerary{} = itinerary} = Itineraries.update_itinerary(itinerary, update_attrs)
      assert itinerary.description == "some updated description"
      assert itinerary.title == "some updated title"
      assert itinerary.start_date == ~D[2024-09-19]
      assert itinerary.end_date == ~D[2024-09-19]
    end

    test "update_itinerary/2 with invalid data returns error changeset" do
      itinerary = itinerary_fixture()
      assert {:error, %Ecto.Changeset{}} = Itineraries.update_itinerary(itinerary, @invalid_attrs)
      assert itinerary == Itineraries.get_itinerary!(itinerary.id)
    end

    test "delete_itinerary/1 deletes the itinerary" do
      itinerary = itinerary_fixture()
      assert {:ok, %Itinerary{}} = Itineraries.delete_itinerary(itinerary)
      assert_raise Ecto.NoResultsError, fn -> Itineraries.get_itinerary!(itinerary.id) end
    end

    test "change_itinerary/1 returns a itinerary changeset" do
      itinerary = itinerary_fixture()
      assert %Ecto.Changeset{} = Itineraries.change_itinerary(itinerary)
    end
  end
end