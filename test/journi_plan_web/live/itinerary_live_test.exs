defmodule JourniPlanWeb.ItineraryLiveTest do
  use JourniPlanWeb.ConnCase

  import Phoenix.LiveViewTest
  import JourniPlan.ItinerariesFixtures

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  defp create_itinerary(_) do
    itinerary = itinerary_fixture()
    %{itinerary: itinerary}
  end

  describe "Index" do
    setup [:create_itinerary]

    test "lists all itineraries", %{conn: conn, itinerary: itinerary} do
      {:ok, _index_live, html} = live(conn, ~p"/itineraries")

      assert html =~ "Listing Itineraries"
      assert html =~ itinerary.description
    end

    test "saves new itinerary", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/itineraries")

      assert index_live |> element("a", "New Itinerary") |> render_click() =~
               "New Itinerary"

      assert_patch(index_live, ~p"/itineraries/new")

      assert index_live
             |> form("#itinerary-form", itinerary: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#itinerary-form", itinerary: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/itineraries")

      html = render(index_live)
      assert html =~ "Itinerary created successfully"
      assert html =~ "some description"
    end

    test "updates itinerary in listing", %{conn: conn, itinerary: itinerary} do
      {:ok, index_live, _html} = live(conn, ~p"/itineraries")

      assert index_live |> element("##{itinerary.uuid} a", "Edit") |> render_click() =~
               "Edit Itinerary"

      assert_patch(index_live, ~p"/itineraries/#{itinerary}/edit")

      assert index_live
             |> form("#itinerary-form", itinerary: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#itinerary-form", itinerary: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/itineraries")

      html = render(index_live)
      assert html =~ "Itinerary updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes itinerary in listing", %{conn: conn, itinerary: itinerary} do
      {:ok, index_live, _html} = live(conn, ~p"/itineraries")

      assert index_live |> element("##{itinerary.uuid} a", "Delete") |> render_click()
      refute has_element?(index_live, "##{itinerary.uuid}")
    end
  end

  describe "Show" do
    setup [:create_itinerary]

    test "displays itinerary", %{conn: conn, itinerary: itinerary} do
      {:ok, _show_live, html} = live(conn, ~p"/itineraries/#{itinerary}")

      assert html =~ "Show Itinerary"
      assert html =~ itinerary.description
    end

    test "updates itinerary within modal", %{conn: conn, itinerary: itinerary} do
      {:ok, show_live, _html} = live(conn, ~p"/itineraries/#{itinerary}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Itinerary"

      assert_patch(show_live, ~p"/itineraries/#{itinerary}/show/edit")

      assert show_live
             |> form("#itinerary-form", itinerary: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#itinerary-form", itinerary: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/itineraries/#{itinerary}")

      html = render(show_live)
      assert html =~ "Itinerary updated successfully"
      assert html =~ "some updated description"
    end
  end
end
