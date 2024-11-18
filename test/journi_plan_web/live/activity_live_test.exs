defmodule JourniPlanWeb.ActivityLiveTest do
  use JourniPlanWeb.ConnCase

  import Phoenix.LiveViewTest
  alias JourniPlan.Accounts
  import JourniPlan.ItinerariesFixtures

  @create_attrs %{
    description: "some description",
    end_time: "2024-09-30T17:57",
    name: "some name",
    start_time: "2024-09-30T17:57"
  }
  @update_attrs %{
    description: "some updated description",
    end_time: "2024-10-01T17:57",
    name: "some updated name",
    start_time: "2024-10-01T17:57"
  }
  @invalid_attrs %{description: nil, end_time: nil, name: nil, start_time: nil}

  setup do
    {:ok, user} =
      %{email: "test@example.com", password: "passwordpassword123"}
      |> Accounts.register_user()

    activity = activity_fixture(%{"user_id" => user.id})

    {:ok, conn: log_in_user(build_conn(), user), user: user, activity: activity}
  end

  describe "Index" do
    test "lists all activities", %{conn: conn, activity: activity} do
      {:ok, _index_live, html} = live(conn, ~p"/activities")

      assert html =~ "Listing Activities"
      assert html =~ activity.description
    end

    test "saves new activity", %{conn: conn, activity: activity} do
      {:ok, index_live, _html} =
        live(conn, ~p"/itineraries/#{activity.itinerary_uuid}/activities/new")

      assert index_live
             |> form("#activity-form", activity: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#activity-form", activity: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/activities")

      html = render(index_live)
      assert html =~ "Activity created successfully"
      assert html =~ "some description"
    end

    test "updates activity in listing", %{conn: conn, activity: activity} do
      {:ok, index_live, _html} = live(conn, ~p"/activities")

      assert index_live |> element("##{activity.uuid} a", "Edit") |> render_click() =~
               "Edit Activity"

      assert_patch(index_live, ~p"/activities/#{activity}/edit")

      assert index_live
             |> form("#activity-form", activity: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#activity-form", activity: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/activities")

      html = render(index_live)
      assert html =~ "Activity updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes activity in listing", %{conn: conn, activity: activity} do
      {:ok, index_live, _html} = live(conn, ~p"/activities")

      assert index_live |> element("##{activity.uuid} a", "Delete") |> render_click()
      refute has_element?(index_live, "##{activity.uuid}")
    end
  end

  describe "Show" do
    test "displays activity", %{conn: conn, activity: activity} do
      {:ok, _show_live, html} = live(conn, ~p"/activities/#{activity}")

      assert html =~ "Show Activity"
      assert html =~ activity.description
    end

    test "updates activity within modal", %{conn: conn, activity: activity} do
      {:ok, show_live, _html} = live(conn, ~p"/activities/#{activity}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Activity"

      assert_patch(show_live, ~p"/activities/#{activity}/show/edit")

      assert show_live
             |> form("#activity-form", activity: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#activity-form", activity: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/activities/#{activity}")

      html = render(show_live)
      assert html =~ "Activity updated successfully"
      assert html =~ "some updated description"
    end
  end
end
