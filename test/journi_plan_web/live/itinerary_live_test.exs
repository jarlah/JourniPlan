defmodule JourniPlanWeb.ItineraryLiveTest do
  use JourniPlanWeb.ConnCase

  import Phoenix.LiveViewTest
  import JourniPlan.ItinerariesFixtures
  import JourniPlan.AccountsFixtures

  @create_attrs %{description: "some description", title: "some title", start_date: "2024-09-18", end_date: "2024-09-18"}
  @update_attrs %{description: "some updated description", title: "some updated title", start_date: "2024-09-19", end_date: "2024-09-19"}
  @invalid_attrs %{description: nil, title: nil, start_date: nil, end_date: nil}

  defp create_itinerary(_) do
    user = user_fixture()
    itinerary = itinerary_fixture(%{ user_id: user.id })
    %{itinerary: itinerary, user: user}
  end

  describe "Index" do
    setup [:create_itinerary]

    test "lists all itineraries", %{conn: conn, itinerary: itinerary, user: user} do
      {:ok, _lv, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/itineraries")

      assert html =~ "Listing Itineraries"
      assert html =~ itinerary.description
    end

    test "saves new itinerary", %{conn: conn, user: user} do
      {:ok, index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/itineraries")

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

    test "updates itinerary in listing", %{conn: conn, itinerary: itinerary, user: user} do
      {:ok, index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/itineraries")

      assert index_live |> element("#itineraries-#{itinerary.id} a", "Edit") |> render_click() =~
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

    test "deletes itinerary in listing", %{conn: conn, itinerary: itinerary, user: user} do
      {:ok, index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/itineraries")

      assert index_live |> element("#itineraries-#{itinerary.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#itineraries-#{itinerary.id}")
    end
  end

  describe "Show" do
    setup [:create_itinerary]

    test "displays itinerary", %{conn: conn, itinerary: itinerary, user: user} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/itineraries/#{itinerary}")

      assert html =~ "Show Itinerary"
      assert html =~ itinerary.description
    end

    test "updates itinerary within modal", %{conn: conn, itinerary: itinerary, user: user} do
      {:ok, show_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/itineraries/#{itinerary}")

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
