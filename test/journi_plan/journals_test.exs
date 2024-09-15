defmodule JourniPlan.JournalsTest do
  use JourniPlan.DataCase

  alias JourniPlan.Journals

  describe "journals" do
    alias JourniPlan.Journals.Journal

    import JourniPlan.AccountsFixtures
    import JourniPlan.JournalsFixtures

    @invalid_attrs %{description: nil, is_public: nil, title: nil}

    test "list_journals/0 returns all journals" do
      user = user_fixture()
      journal = journal_fixture(%{ user_id: user.id })
      assert Journals.list_journals() == [journal]
    end

    test "get_journal!/1 returns the journal with given id" do
      user = user_fixture()
      journal = journal_fixture(%{ user_id: user.id })
      assert Journals.get_journal!(journal.id) == journal
    end

    test "create_journal/1 with valid data creates a journal" do
      user = user_fixture()
      valid_attrs = %{description: "some description", is_public: true, title: "some title", user_id: user.id}

      assert {:ok, %Journal{} = journal} = Journals.create_journal(valid_attrs)
      assert journal.description == "some description"
      assert journal.is_public == true
      assert journal.title == "some title"
    end

    test "create_journal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Journals.create_journal(@invalid_attrs)
    end

    test "update_journal/2 with valid data updates the journal" do
      user = user_fixture()
      journal = journal_fixture(%{ user_id: user.id })
      update_attrs = %{description: "some updated description", is_public: false, title: "some updated title"}

      assert {:ok, %Journal{} = journal} = Journals.update_journal(journal, update_attrs)
      assert journal.description == "some updated description"
      assert journal.is_public == false
      assert journal.title == "some updated title"
    end

    test "update_journal/2 with invalid data returns error changeset" do
      user = user_fixture()
      journal = journal_fixture(%{ user_id: user.id })
      assert {:error, %Ecto.Changeset{}} = Journals.update_journal(journal, @invalid_attrs)
      assert journal == Journals.get_journal!(journal.id)
    end

    test "delete_journal/1 deletes the journal" do
      user = user_fixture()
      journal = journal_fixture(%{ user_id: user.id })
      assert {:ok, %Journal{}} = Journals.delete_journal(journal)
      assert_raise Ecto.NoResultsError, fn -> Journals.get_journal!(journal.id) end
    end

    test "change_journal/1 returns a journal changeset" do
      user = user_fixture()
      journal = journal_fixture(%{ user_id: user.id })
      assert %Ecto.Changeset{} = Journals.change_journal(journal)
    end
  end

  describe "entries" do
    alias JourniPlan.Journals.Entry

    import JourniPlan.AccountsFixtures
    import JourniPlan.JournalsFixtures

    @invalid_attrs %{body: nil, inserted_at: nil, title: nil}

    test "list_entries/0 returns all entries" do
      user = user_fixture()
      journal = journal_fixture(%{ user_id: user.id })
      entry = entry_fixture(%{ journal_id: journal.id })
      assert Journals.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      user = user_fixture()
      journal = journal_fixture(%{ user_id: user.id })
      entry = entry_fixture(%{ journal_id: journal.id })
      assert Journals.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      user = user_fixture()
      journal = journal_fixture(%{ user_id: user.id })
      valid_attrs = %{body: "some body", title: "some title", journal_id: journal.id}

      assert {:ok, %Entry{} = entry} = Journals.create_entry(valid_attrs)
      assert entry.body == "some body"
      assert entry.title == "some title"
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Journals.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      user = user_fixture()
      journal = journal_fixture(%{ user_id: user.id })
      entry = entry_fixture(%{ journal_id: journal.id })
      update_attrs = %{body: "some updated body", title: "some updated title"}

      assert {:ok, %Entry{} = entry} = Journals.update_entry(entry, update_attrs)
      assert entry.body == "some updated body"
      assert entry.title == "some updated title"
    end

    test "update_entry/2 with invalid data returns error changeset" do
      user = user_fixture()
      journal = journal_fixture(%{ user_id: user.id })
      entry = entry_fixture(%{ journal_id: journal.id })
      assert {:error, %Ecto.Changeset{}} = Journals.update_entry(entry, @invalid_attrs)
      assert entry == Journals.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      user = user_fixture()
      journal = journal_fixture(%{ user_id: user.id })
      entry = entry_fixture(%{ journal_id: journal.id })
      assert {:ok, %Entry{}} = Journals.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Journals.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      user = user_fixture()
      journal = journal_fixture(%{ user_id: user.id })
      entry = entry_fixture(%{ journal_id: journal.id })
      assert %Ecto.Changeset{} = Journals.change_entry(entry)
    end
  end
end
