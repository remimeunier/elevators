defmodule Elevator.ElevatorBucket do
  use Agent
  require MyConstants
  alias MyConstants, as: Const

  @doc """
  Starts a new bucket.
  """
  def start_link(initial_floor) do
    Agent.start_link(fn -> %{current_position: initial_floor,
                             destination: [],
                             iddle_destination: [],
                             state: Const.state_idle} end)
  end

  @doc """
  Gets a value from the `bucket` by `key`.
  """
  def get(bucket) do
    Agent.get(bucket, fn list -> list end)
  end

  @doc """
  add 1 to current_position.
  """
  def go_up(bucket) do
    Agent.update(bucket, &Map.update!(&1, :current_position, fn value -> value + 1 end))
  end

  @doc """
  Substract 1 to current_position.
  """
  def go_down(bucket) do
    Agent.update(bucket, &Map.update!(&1, :current_position, fn value -> value - 1 end))
  end

  @doc """
  Add a new iddle destination at the end of the destination list
  """
  # def add_destination(bucket, value) do
  #   Agent.update(bucket, &Map.update!(&1, :destination, fn list ->
  #     list ++ [value]
  #   end))
  # end

  # @doc """
  # Add a new destination at the end of the destination list
  # """
  # def add_iddle_destination(bucket, value) do
  #   Agent.update(bucket, &Map.update!(&1, :iddle_destination, fn list ->
  #     list ++ [value]
  #   end))
  # end

  @doc """
  Set the state to value
  """
  def set_state(bucket, value) do
    Agent.update(bucket, &Map.update!(&1, :state, fn elem ->
      value
    end))
  end

  @doc """
  Add a new destination at the end of the destination list
  """
  def add_destination(bucket, value) do
    # TODO return if already exist or if equal to current position
    # current_position = Map.get(dict, :current_position)
    Agent.update(bucket, fn dict ->
       Elevator.ChoiceMaker.add_destination_to_elevator(dict, value)
    end)
  end

  @doc """
  Add a new destination at the end of the destination list
  """
  # def add_destination(bucket, value) do
  # #   # TODO return if already exist or if equal to current position
  #   current_position = Map.get(dict, :current_position)
  #   Agent.update(bucket, fn dict ->
  #       case Map.get(dict, :direction) do
  #         nil ->
  #           Map.update!(dict, :destination, &(&1 ++ [value]))
  #           |> Map.update!(dict, :direction, fn v -> direction(current_position, value) end)
  #         _ when DirectionCalculator.my_direction?(value, current_position, direction) ->
  #           Map.update!(dict, :destination, &(&1 ++ [value]))
  #         _ -> Map.update!(dict, :iddle_destination, &(&1 ++ [value]))

  #       end
  #   end)
    # Agent.update(bucket, fn dict ->
    #   # If the destination exist already, don't do anything
    #   if Enum.member?(Map.get(dict, :destination), value) do
    #     dict
    #   else
    #     case Map.get(dict, :destination) do
    #       []            -> Map.update!(dict, :destination, fn _list -> [value] end)
    #       [head | tail] when dict[:current_position] ->
    #         Map.update!(dict, :destination, fn list -> list ++ [value] end)
    #     end
    #   end
    # end)
  #end

  @doc """
  remoove the given destination, if destination if empty, it switchs states
  and add iddle destiantion in destination
  """
  # def remoove_destination(bucket, destination) do
  #   Agent.update(bucket, &Map.update!(&1, :destination, fn list ->
  #     Enum.filter(list, fn el -> el != destination end)
  #   end))
  # end

  def remoove_destination(bucket, destination) do
    Agent.update(bucket, fn dict ->
      # remoove destination
      new_value = Map.update!(dict, :destination, fn list ->
        Enum.filter(list, fn el -> el != destination end)
      end)
      case new_value do
        %{destination: []} ->
          Map.update!(new_value, :destination, fn list -> Map.get(dict,:iddle_destination) end)
          |> Map.update!(:iddle_destination, fn list -> [] end)
          |> Map.update!(:state, fn elem -> elem * (-1) end)
        _                   -> new_value
      end
    end)
  end
end
