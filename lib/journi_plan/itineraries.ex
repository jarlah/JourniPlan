defmodule JourniPlan.Itineraries do
  import Ecto.Query, warn: false
  alias JourniPlan.App
  alias JourniPlan.Repo

  alias JourniPlan.Itineraries.Commands.{
    CreateItinerary,
    UpdateItinerary,
    DeleteItinerary,
    CreateActivity,
    UpdateActivity,
    DeleteActivity,
    CreateJournalEntry,
    UpdateJournalEntry,
    DeleteJournalEntry
  }

  alias JourniPlan.Itineraries.Projections.Itinerary
  alias JourniPlan.Itineraries.Projections.Activity
  alias JourniPlan.Itineraries.Projections.JournalEntry

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

  def change_itinerary(itinerary, action, params \\ nil)

  def change_itinerary(%Itinerary{} = itinerary, :edit, params) do
    UpdateItinerary.changeset(
      %UpdateItinerary{uuid: itinerary.uuid},
      params || Map.from_struct(itinerary)
    )
  end

  def change_itinerary(_itinerary, :new, params) do
    CreateItinerary.changeset(
      %CreateItinerary{},
      params || %{}
    )
  end

  def create_itinerary(attrs \\ %{}) do
    uuid = Ecto.UUID.generate()

    command =
      attrs
      |> CreateItinerary.new()
      |> CreateItinerary.assign_uuid(uuid)

    changeset = CreateItinerary.changeset(command, attrs)

    if changeset.valid? do
      with :ok <- App.dispatch(command, consistency: :strong) do
        {:ok, get_itinerary!(uuid)}
      else
        reply -> reply
      end
    else
      {:error, changeset}
    end
  end

  def update_itinerary(%Itinerary{uuid: uuid}, attrs) do
    command =
      attrs
      |> UpdateItinerary.new()
      |> UpdateItinerary.assign_uuid(uuid)

    changeset = UpdateItinerary.changeset(command, attrs)

    if changeset.valid? do
      with :ok <- App.dispatch(command, consistency: :strong) do
        {:ok, get_itinerary!(uuid)}
      else
        reply -> reply
      end
    else
      {:error, changeset}
    end
  end

  def delete_itinerary(%Itinerary{uuid: uuid} = itinerary) do
    command = %DeleteItinerary{uuid: uuid}

    with :ok <- App.dispatch(command, consistency: :strong) do
      {:ok, itinerary}
    else
      reply -> reply
    end
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

    command =
      attrs
      |> CreateActivity.new()
      |> CreateActivity.assign_uuid(uuid)

    changeset = CreateActivity.changeset(command, attrs)

    if changeset.valid? do
      with :ok <- App.dispatch(command, consistency: :strong) do
        {:ok, get_activity!(uuid)}
      else
        reply -> reply
      end
    else
      {:error, changeset}
    end
  end

  def update_activity(%Activity{uuid: uuid}, attrs) do
    command =
      attrs
      |> UpdateActivity.new()
      |> UpdateActivity.assign_uuid(uuid)

    changeset = UpdateActivity.changeset(command, attrs)

    if changeset.valid? do
      with :ok <- App.dispatch(command, consistency: :strong) do
        {:ok, get_activity!(uuid)}
      else
        reply -> reply
      end
    else
      {:error, changeset}
    end
  end

  def delete_activity(%Activity{uuid: uuid} = activity) do
    command = %DeleteActivity{uuid: uuid}

    with :ok <- App.dispatch(command, consistency: :strong) do
      {:ok, activity}
    else
      reply -> reply
    end
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

  def change_activity(activity, action, params \\ nil)

  def change_activity(%Activity{} = activity, :edit, params) do
    UpdateActivity.changeset(
      %UpdateActivity{uuid: activity.uuid},
      params || Map.from_struct(activity)
    )
  end

  def change_activity(_activity, :new, params) do
    CreateActivity.changeset(
      %CreateActivity{},
      params || %{}
    )
  end

  def change_journal_entry(journal_entry, action, params \\ nil)

  def change_journal_entry(%JournalEntry{} = journal_entry, :edit, params) do
    UpdateJournalEntry.changeset(
      %UpdateJournalEntry{uuid: journal_entry.uuid},
      params || Map.from_struct(journal_entry)
    )
  end

  def change_journal_entry(_journal_entry, :new, params) do
    CreateJournalEntry.changeset(
      %CreateJournalEntry{},
      params || %{}
    )
  end

  def create_journal_entry(attrs \\ %{}) do
    uuid = Ecto.UUID.generate()

    command =
      attrs
      |> CreateJournalEntry.new()
      |> CreateJournalEntry.assign_uuid(uuid)

    changeset = CreateJournalEntry.changeset(command, attrs)

    if changeset.valid? do
      with :ok <- App.dispatch(command, consistency: :strong) do
        {:ok, get_journal_entry!(uuid)}
      else
        reply -> reply
      end
    else
      {:error, changeset}
    end
  end

  def update_journal_entry(%JournalEntry{uuid: uuid}, attrs) do
    command =
      attrs
      |> UpdateJournalEntry.new()
      |> UpdateJournalEntry.assign_uuid(uuid)

    changeset = UpdateJournalEntry.changeset(command, attrs)

    if changeset.valid? do
      with :ok <- App.dispatch(command, consistency: :strong) do
        {:ok, get_journal_entry!(uuid)}
      else
        reply -> reply
      end
    else
      {:error, changeset}
    end
  end

  def delete_journal_entry(%JournalEntry{uuid: uuid} = journal_entry) do
    command = %DeleteJournalEntry{uuid: uuid}

    with :ok <- App.dispatch(command, consistency: :strong) do
      {:ok, journal_entry}
    else
      reply -> reply
    end
  end
end
