defmodule JourniPlan.MediasTest do
  use JourniPlan.DataCase

  alias JourniPlan.Medias

  describe "medias" do
    alias JourniPlan.Medias.Media

    import JourniPlan.MediasFixtures

    @invalid_attrs %{media_type: nil, media_url: nil}

    test "list_medias/0 returns all medias" do
      media = media_fixture()
      assert Medias.list_medias() == [media]
    end

    test "get_media!/1 returns the media with given id" do
      media = media_fixture()
      assert Medias.get_media!(media.id) == media
    end

    test "create_media/1 with valid data creates a media" do
      valid_attrs = %{name: "some name", media_type: "some media_type", media_url: "some media_url"}

      assert {:ok, %Media{} = media} = Medias.create_media(valid_attrs)
      assert media.media_type == "some media_type"
      assert media.media_url == "some media_url"
    end

    test "create_media/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Medias.create_media(@invalid_attrs)
    end

    test "update_media/2 with valid data updates the media" do
      media = media_fixture()
      update_attrs = %{name: "some updated name", media_type: "some updated media_type", media_url: "some updated media_url"}

      assert {:ok, %Media{} = media} = Medias.update_media(media, update_attrs)
      assert media.media_type == "some updated media_type"
      assert media.media_url == "some updated media_url"
      assert media.name == "some updated name"
    end

    test "update_media/2 with invalid data returns error changeset" do
      media = media_fixture()
      assert {:error, %Ecto.Changeset{}} = Medias.update_media(media, @invalid_attrs)
      assert media == Medias.get_media!(media.id)
    end

    test "delete_media/1 deletes the media" do
      media = media_fixture()
      assert {:ok, %Media{}} = Medias.delete_media(media)
      assert_raise Ecto.NoResultsError, fn -> Medias.get_media!(media.id) end
    end

    test "change_media/1 returns a media changeset" do
      media = media_fixture()
      assert %Ecto.Changeset{} = Medias.change_media(media)
    end
  end
end
