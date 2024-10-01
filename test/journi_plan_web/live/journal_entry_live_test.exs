defmodule JourniPlanWeb.JournalEntryLiveTest do
  use JourniPlanWeb.ConnCase

  import Phoenix.LiveViewTest
  alias JourniPlan.Accounts

  import JourniPlan.ItinerariesFixtures

  @create_attrs %{body: "some body", entry_date: "2024-09-30T17:55:00Z", title: "some title"}
  @update_attrs %{body: "some updated body", entry_date: "2024-10-01T17:55:00Z", title: "some updated title"}
  @invalid_attrs %{body: nil, entry_date: nil, title: nil}

  setup do
    {:ok, user} =
      %{email: "test@example.com", password: "passwordpassword123"}
      |> Accounts.register_user()

      journal_entry = journal_entry_fixture(%{user_id: user.id})

    {:ok, conn: log_in_user(build_conn(), user), user: user, journal_entry: journal_entry}
  end

  describe "Index" do

    test "lists all journal_entries", %{conn: conn, journal_entry: journal_entry} do
      {:ok, _index_live, html} = live(conn, ~p"/journal_entries")

      assert html =~ "Listing Journal entries"
      assert html =~ journal_entry.body
    end

    test "saves new journal_entry", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/journal_entries")

      assert index_live |> element("a", "New Journal entry") |> render_click() =~
               "New Journal entry"

      assert_patch(index_live, ~p"/journal_entries/new")

      assert index_live
             |> form("#journal_entry-form", journal_entry: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#journal_entry-form", journal_entry: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/journal_entries")

      html = render(index_live)
      assert html =~ "Journal entry created successfully"
      assert html =~ "some body"
    end

    test "updates journal_entry in listing", %{conn: conn, journal_entry: journal_entry} do
      {:ok, index_live, _html} = live(conn, ~p"/journal_entries")

      assert index_live |> element("##{journal_entry.uuid} a", "Edit") |> render_click() =~
               "Edit Journal entry"

      assert_patch(index_live, ~p"/journal_entries/#{journal_entry}/edit")

      assert index_live
             |> form("#journal_entry-form", journal_entry: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#journal_entry-form", journal_entry: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/journal_entries")

      html = render(index_live)
      assert html =~ "Journal entry updated successfully"
      assert html =~ "some updated body"
    end

    test "deletes journal_entry in listing", %{conn: conn, journal_entry: journal_entry} do
      {:ok, index_live, _html} = live(conn, ~p"/journal_entries")

      assert index_live |> element("##{journal_entry.uuid} a", "Delete") |> render_click()
      refute has_element?(index_live, "##{journal_entry.uuid}")
    end
  end

  describe "Show" do

    test "displays journal_entry", %{conn: conn, journal_entry: journal_entry} do
      {:ok, _show_live, html} = live(conn, ~p"/journal_entries/#{journal_entry}")

      assert html =~ "Show Journal entry"
      assert html =~ journal_entry.body
    end

    test "updates journal_entry within modal", %{conn: conn, journal_entry: journal_entry} do
      {:ok, show_live, _html} = live(conn, ~p"/journal_entries/#{journal_entry}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Journal entry"

      assert_patch(show_live, ~p"/journal_entries/#{journal_entry}/show/edit")

      assert show_live
             |> form("#journal_entry-form", journal_entry: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#journal_entry-form", journal_entry: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/journal_entries/#{journal_entry}")

      html = render(show_live)
      assert html =~ "Journal entry updated successfully"
      assert html =~ "some updated body"
    end
  end
end
