defmodule JourniPlan.Itineraries.Aggregates.Activity do
  defstruct [
    :uuid,
    :name,
    :description,
    :start_time,
    :end_time,
    :itinerary_id,
    :user_id
  ]

  alias JourniPlan.Itineraries.Commands.CreateActivity
  alias JourniPlan.Itineraries.Commands.UpdateActivity
  alias JourniPlan.Itineraries.Commands.DeleteActivity
  alias JourniPlan.Itineraries.Events.ActivityCreated
  alias JourniPlan.Itineraries.Events.ActivityNameUpdated
  alias JourniPlan.Itineraries.Events.ActivityDescriptionUpdated
  alias JourniPlan.Itineraries.Events.ActivityStartTimeUpdated
  alias JourniPlan.Itineraries.Events.ActivityEndTimeUpdated
  alias JourniPlan.Itineraries.Events.ActivityDeleted

  alias JourniPlan.Itineraries.Aggregates.Activity

  def execute(%Activity{uuid: nil}, %CreateActivity{} = event) do
    %ActivityCreated{
      uuid: event.uuid,
      name: event.name,
      description: event.description,
      start_time: event.start_time,
      end_time: event.end_time,
      itinerary_id: event.itinerary_id,
      user_id: event.user_id
    }
  end

  def execute(%Activity{} = activity, %UpdateActivity{} = event) do
    name_command =
      if activity.name != event.name and not is_nil(event.name),
        do: %ActivityNameUpdated{uuid: activity.uuid, name: event.name}

    description_command =
      if activity.description != event.description and not is_nil(event.description),
        do: %ActivityDescriptionUpdated{uuid: activity.uuid, description: event.description}

    start_time_command =
      if activity.start_time != event.start_time and not is_nil(event.start_time),
        do: %ActivityStartTimeUpdated{uuid: activity.uuid, start_time: event.start_time}

    end_time_command =
      if activity.end_time != event.end_time and not is_nil(event.end_time),
        do: %ActivityEndTimeUpdated{uuid: activity.uuid, end_time: event.end_time}

    [name_command, description_command, start_time_command, end_time_command] |> Enum.filter(&Function.identity/1)
  end

  def execute(%Activity{}, %DeleteActivity{} = event) do
    %ActivityDeleted{uuid: event.uuid}
  end

  def apply(%Activity{} = activity, %ActivityCreated{} = event) do
    %Activity{
      activity
      | uuid: event.uuid,
        name: event.name,
        description: event.description,
        start_time: event.start_time,
        end_time: event.end_time,
        itinerary_id: event.itinerary_id,
        user_id: event.user_id
    }
  end

  def apply(%Activity{} = activity, %ActivityNameUpdated{} = event) do
    %Activity{activity | name: event.name}
  end

  def apply(%Activity{} = activity, %ActivityDescriptionUpdated{} = event) do
    %Activity{activity | description: event.description}
  end

  def apply(%Activity{} = activity, %ActivityStartTimeUpdated{} = event) do
    %Activity{activity | start_time: event.start_time}
  end

  def apply(%Activity{} = activity, %ActivityEndTimeUpdated{} = event) do
    %Activity{activity | end_time: event.end_time}
  end

  def apply(%Activity{}, %ActivityDeleted{}) do
    nil
  end
end
