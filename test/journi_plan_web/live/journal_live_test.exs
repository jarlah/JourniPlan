defmodule JourniPlanWeb.JournalLiveTest do
  use JourniPlanWeb.ConnCase, async: true

  import JourniPlan.JournalsFixtures
  import JourniPlan.AccountsFixtures
  import Phoenix.LiveViewTest

  @create_attrs %{title: "Test title", description: "Test description"}
  @update_attrs %{title: "Updated test title", description: "Updated test description"}
  @invalid_attrs %{title: "", description: ""}

  defp create_journal(_) do
    user = user_fixture()
    journal = journal_fixture(%{ user_id: user.id })
    %{journal: journal}
  end

  describe "Index" do
    setup [:create_journal]

    test "lists all journals", %{conn: conn} do
      {:ok, _lv, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/journals")

      assert html =~ "Listing Journals"
    end

    test "saves new journal", %{conn: conn} do
      {:ok, index_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/journals")

      assert index_live |> element("a", "New Journal") |> render_click() =~
               "New Journal"

      assert_patch(index_live, ~p"/journals/new")

      assert index_live
             |> form("#journal-form", journal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#journal-form", journal: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/journals")

      html = render(index_live)
      assert html =~ "Journal created successfully"
    end

    test "updates journal in listing", %{conn: conn, journal: journal} do
      {:ok, index_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/journals")

      assert index_live |> element("#journals-#{journal.id} a", "Edit") |> render_click() =~
               "Edit Journal"

      assert_patch(index_live, ~p"/journals/#{journal}/edit")

      assert index_live
             |> form("#journal-form", journal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#journal-form", journal: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/journals")

      html = render(index_live)
      assert html =~ "Journal updated successfully"
    end

    test "deletes journal in listing", %{conn: conn, journal: journal} do
      {:ok, index_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/journals")

      assert index_live |> element("#journals-#{journal.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#journals-#{journal.id}")
    end
  end

  describe "Show" do
    setup [:create_journal]

    test "displays journal", %{conn: conn, journal: journal} do
      {:ok, _live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/journals/#{journal}")

      assert html =~ "Show Journal"
    end

    test "updates journal within modal", %{conn: conn, journal: journal} do
      {:ok, show_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/journals/#{journal}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Journal"

      assert_patch(show_live, ~p"/journals/#{journal}/show/edit")

      assert show_live
             |> form("#journal-form", journal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#journal-form", journal: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/journals/#{journal}")

      html = render(show_live)
      assert html =~ "Journal updated successfully"
    end
  end
end
