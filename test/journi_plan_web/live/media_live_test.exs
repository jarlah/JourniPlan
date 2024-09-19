defmodule JourniPlanWeb.MediaLiveTest do
  use JourniPlanWeb.ConnCase

  import Phoenix.LiveViewTest
  import JourniPlan.MediasFixtures
  import JourniPlan.AccountsFixtures
  import JourniPlan.JournalsFixtures

  @create_attrs %{name: "some name", media_type: "some media_type", media_url: "some media_url"}
  @update_attrs %{name: "some updated name", media_type: "some updated media_type", media_url: "some updated media_url"}
  @invalid_attrs %{name: nil, media_type: nil, media_url: nil}

  defp create_media(_) do
    user = user_fixture()
    journal = journal_fixture(%{ user_id: user.id })
    entry = entry_fixture(%{journal_id: journal.id})
    media = media_fixture(%{ entry_id: entry.id })
    %{media: media, user: user}
  end

  describe "Index" do
    setup [:create_media]

    test "lists all medias", %{conn: conn, media: media, user: user} do
      {:ok, _lv, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/medias")

      assert html =~ "Listing Medias"
      assert html =~ media.media_type
    end

    test "saves new media", %{conn: conn, user: user} do
      {:ok, index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/medias")

      assert index_live |> element("a", "New Media") |> render_click() =~
               "New Media"

      assert_patch(index_live, ~p"/medias/new")

      assert index_live
             |> form("#media-form", media: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#media-form", media: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/medias")

      html = render(index_live)
      assert html =~ "Media created successfully"
      assert html =~ "some media_type"
    end

    test "updates media in listing", %{conn: conn, media: media, user: user} do
      {:ok, index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/medias")

      assert index_live |> element("#medias-#{media.id} a", "Edit") |> render_click() =~
               "Edit Media"

      assert_patch(index_live, ~p"/medias/#{media}/edit")

      assert index_live
             |> form("#media-form", media: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#media-form", media: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/medias")

      html = render(index_live)
      assert html =~ "Media updated successfully"
      assert html =~ "some updated media_type"
    end

    test "deletes media in listing", %{conn: conn, media: media, user: user} do
      {:ok, index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/medias")

      assert index_live |> element("#medias-#{media.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#medias-#{media.id}")
    end
  end

  describe "Show" do
    setup [:create_media]

    test "displays media", %{conn: conn, media: media, user: user} do
      {:ok, _lv, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/medias/#{media}")

      assert html =~ "Show Media"
      assert html =~ media.media_type
    end

    test "updates media within modal", %{conn: conn, media: media, user: user} do
      {:ok, show_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/medias/#{media}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Media"

      assert_patch(show_live, ~p"/medias/#{media}/show/edit")

      assert show_live
             |> form("#media-form", media: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#media-form", media: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/medias/#{media}")

      html = render(show_live)
      assert html =~ "Media updated successfully"
      assert html =~ "some updated media_type"
    end
  end
end
