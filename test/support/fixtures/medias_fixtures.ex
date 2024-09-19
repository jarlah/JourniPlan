defmodule JourniPlan.MediasFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `JourniPlan.Medias` context.
  """

  @doc """
  Generate a media.
  """
  def media_fixture(attrs \\ %{}) do
    {:ok, media} =
      attrs
      |> Enum.into(%{
        name: "some name",
        media_type: "some media_type",
        media_url: "some media_url"
      })
      |> JourniPlan.Medias.create_media()

    media
  end
end
