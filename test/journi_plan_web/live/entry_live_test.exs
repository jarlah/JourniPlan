defmodule JourniPlanWeb.EntryLiveTest do
  use JourniPlanWeb.ConnCase

  import Phoenix.LiveViewTest
  import JourniPlan.AccountsFixtures
  import JourniPlan.JournalsFixtures

  @create_attrs %{title: "Test title", body: "Test body"}
  @update_attrs %{title: "Updated test title", body: "Updated test body"}
  @invalid_attrs %{title: "", body: ""}

  defp create_entry(_) do
    journal = journal_fixture()
    entry = entry_fixture(%{journal_id: journal.id})
    %{entry: entry}
  end

  describe "Index" do
    setup [:create_entry]

    test "lists all entries", %{conn: conn} do
      {:ok, _lv, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/entries")

      assert html =~ "Listing Entries"
    end

    test "saves new entry", %{conn: conn} do
      {:ok, index_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/entries")

      assert index_live |> element("a", "New Entry") |> render_click() =~
               "New Entry"

      assert_patch(index_live, ~p"/entries/new")

      assert index_live
             |> form("#entry-form", entry: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#entry-form", entry: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/entries")

      html = render(index_live)
      assert html =~ "Entry created successfully"
    end

    test "updates entry in listing", %{conn: conn, entry: entry} do
      {:ok, index_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/entries")

      assert index_live |> element("#entries-#{entry.id} a", "Edit") |> render_click() =~
               "Edit Entry"

      assert_patch(index_live, ~p"/entries/#{entry}/edit")

      assert index_live
             |> form("#entry-form", entry: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#entry-form", entry: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/entries")

      html = render(index_live)
      assert html =~ "Entry updated successfully"
    end

    test "deletes entry in listing", %{conn: conn, entry: entry} do
      {:ok, index_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/entries")

      assert index_live |> element("#entries-#{entry.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#entries-#{entry.id}")
    end
  end

  describe "Show" do
    setup [:create_entry]

    test "displays entry", %{conn: conn, entry: entry} do
      {:ok, _live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/entries/#{entry}")

      assert html =~ "Show Entry"
    end

    test "updates entry within modal", %{conn: conn, entry: entry} do
      {:ok, show_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/entries/#{entry}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Entry"

      assert_patch(show_live, ~p"/entries/#{entry}/show/edit")

      assert show_live
             |> form("#entry-form", entry: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#entry-form", entry: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/entries/#{entry}")

      html = render(show_live)
      assert html =~ "Entry updated successfully"
    end
  end
end
