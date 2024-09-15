defmodule JourniPlan.JournalsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `JourniPlan.Journals` context.
  """

  @doc """
  Generate a journal.
  """
  def journal_fixture(attrs \\ %{}) do
    {:ok, journal} =
      attrs
      |> Enum.into(%{
        description: "some description",
        is_public: true,
        title: "some title"
      })
      |> JourniPlan.Journals.create_journal()

    journal
  end

  @doc """
  Generate a entry.
  """
  def entry_fixture(attrs \\ %{}) do
    {:ok, entry} =
      attrs
      |> Enum.into(%{
        body: "some body",
        inserted_at: ~N[2024-09-14 11:40:00],
        title: "some title"
      })
      |> JourniPlan.Journals.create_entry()

    entry
  end
end
