defmodule JourniPlan.Itineraries do
  use Bond
  import Ecto.Query, warn: false

  alias JourniPlan.Repo

  alias JourniPlan.Itineraries.Itinerary
  alias JourniPlan.Itineraries.Activity
  alias JourniPlan.Itineraries.JournalEntry

  def list_user_itineraries(user_id) do
    from(i in Itinerary, where: i.user_id == ^user_id)
    |> Repo.all()
    |> Repo.preload([:activities, :journal_entries])
  end

  def list_user_journal_entries(user_id) do
    from(j in JournalEntry, where: j.user_id == ^user_id)
    |> Repo.all()
    |> Repo.preload([:activity, :itinerary])
  end

  def get_itinerary!(uuid) do
    Repo.get_by!(Itinerary, uuid: uuid)
    |> Repo.preload([:activities, :journal_entries])
  end

  def change_itinerary(itinerary, action, params \\ %{})

  def change_itinerary(%Itinerary{} = itinerary, :edit, params) do
    itinerary |> Itinerary.changeset(params)
  end

  def change_itinerary(_itinerary, :new, params) do
    %Itinerary{} |> Itinerary.changeset(params)
  end

  @pre attrs_doesnt_have_id: not Map.has_key?(attrs, "uuid")
  def create_itinerary(attrs \\ %{}) do
    uuid = Ecto.UUID.generate()
    attrs = Map.put(attrs, "uuid", uuid)

    changeset = Itinerary.changeset(%Itinerary{}, attrs)

    if changeset.valid? do
      case Repo.insert(changeset) do
        {:ok, itinerary} -> {:ok, itinerary |> Repo.preload([:activities, :journal_entries])}
        {:error, changeset} -> {:error, changeset}
      end
    else
      {:error, changeset}
    end
  end

  def update_itinerary(%Itinerary{uuid: uuid}, attrs) do
    itinerary = get_itinerary!(uuid)
    changeset = Itinerary.changeset(itinerary, attrs)

    if changeset.valid? do
      case Repo.update(changeset) do
        {:ok, itinerary} -> {:ok, itinerary}
        {:error, changeset} -> {:error, changeset}
      end
    else
      {:error, changeset}
    end
  end

  def delete_itinerary(%Itinerary{uuid: uuid}) do
    %Itinerary{uuid: uuid} |> Repo.delete()
  end

  def get_itineraries_by_user_id(user_id) do
    query = from(i in Itinerary, where: i.user_id == ^user_id)

    Repo.all(query)
    |> Repo.preload([:activities, :journal_entries])
  end

  def get_activities_by_itinerary_id(itinerary_uuid) do
    query = from(a in Activity, where: a.itinerary_uuid == ^itinerary_uuid)

    Repo.all(query)
    |> Repo.preload(:itinerary)
  end

  def get_journal_entries_by_itinerary_id(itinerary_uuid) do
    query = from(j in JournalEntry, where: j.itinerary_uuid == ^itinerary_uuid)

    Repo.all(query)
    |> Repo.preload([:activity, :itinerary])
  end

  def get_journal_entries_by_activity_id(activity_uuid) do
    query = from(j in JournalEntry, where: j.activity_uuid == ^activity_uuid)

    Repo.all(query)
    |> Repo.preload([:activity, :itinerary])
  end

  def get_activity!(uuid) do
    Repo.get_by!(Activity, uuid: uuid)
    |> Repo.preload(:itinerary)
  end

  def create_activity(attrs \\ %{}) do
    uuid = Ecto.UUID.generate()
    attrs = Map.put(attrs, "uuid", uuid)
    changeset = Activity.changeset(%Activity{}, attrs)

    if changeset.valid? do
      case Repo.insert(changeset) do
        {:ok, activity} -> {:ok, activity}
        {:error, changeset} -> {:error, changeset}
      end
    else
      {:error, changeset}
    end
  end

  def update_activity(%Activity{uuid: uuid}, attrs) do
    activity = get_activity!(uuid)
    changeset = Activity.changeset(activity, attrs)

    if changeset.valid? do
      case Repo.update(changeset) do
        {:ok, updated_entry} -> {:ok, updated_entry}
        {:error, changeset} -> {:error, changeset}
      end
    else
      {:error, changeset}
    end
  end

  def delete_activity(%Activity{uuid: uuid}) do
    %Activity{uuid: uuid} |> Repo.delete()
  end

  def list_user_activities(user_id) do
    query = from(i in Activity, where: i.user_id == ^user_id)

    Repo.all(query)
    |> Repo.preload(:itinerary)
  end

  def list_journal_entries do
    Repo.all(JournalEntry)
    |> Repo.preload([:activity, :itinerary])
  end

  def get_journal_entry!(uuid) do
    Repo.get_by!(JournalEntry, uuid: uuid)
    |> Repo.preload([:activity, :itinerary])
  end

  def change_activity(activity, action, params \\ %{})

  def change_activity(%Activity{} = activity, :edit, params) do
    activity |> Activity.changeset(params)
  end

  def change_activity(_activity, :new, params) do
    %Activity{} |> Activity.changeset(params)
  end

  def change_journal_entry(journal_entry, action, params \\ %{})

  def change_journal_entry(%JournalEntry{} = journal_entry, :edit, params) do
    journal_entry |> JournalEntry.changeset(params)
  end

  def change_journal_entry(_journal_entry, :new, params) do
    %JournalEntry{} |> JournalEntry.changeset(params)
  end

  def create_journal_entry(attrs \\ %{}) do
    uuid = Ecto.UUID.generate()
    attrs = Map.put(attrs, "uuid", uuid)
    changeset = JournalEntry.changeset(%JournalEntry{}, attrs)

    if changeset.valid? do
      case Repo.insert(changeset) do
        {:ok, journal_entry} -> {:ok, journal_entry}
        {:error, changeset} -> {:error, changeset}
      end
    else
      {:error, changeset}
    end
  end

  def update_journal_entry(%JournalEntry{uuid: uuid}, attrs) do
    journal_entry = get_journal_entry!(uuid)
    changeset = JournalEntry.changeset(journal_entry, attrs)

    if changeset.valid? do
      case Repo.update(changeset) do
        {:ok, updated_entry} -> {:ok, updated_entry}
        {:error, changeset} -> {:error, changeset}
      end
    else
      {:error, changeset}
    end
  end

  def delete_journal_entry(%JournalEntry{uuid: uuid}) do
    %JournalEntry{uuid: uuid} |> Repo.delete()
  end
end
