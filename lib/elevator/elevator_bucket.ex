defmodule Elevator.ElevatorBucket do
  use Agent

  @doc """
  Starts a new bucket.
  """
  def start_link(initial_floor, floor_stops) do
    Agent.start_link(fn -> %{current_position: initial_floor,
                             destination: [],
                             floor_stops: floor_stops} end)
  end

  @doc """
  Gets a value from the `bucket` by `key`.
  """
  def get(bucket) do
    Agent.get(bucket, fn list -> list end)
  end

  # @doc """
  # Gets a value from the `bucket` by `key`.
  # """
  # def get_destination(bucket) do
  #   Agent.get(bucket, fn list -> list[:destination] end)
  # end

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
  Add a new destination at the end of the destination list
  """
  # def add_destination(bucket, value) do
  #   Agent.update(bucket, &Map.update!(&1, :destination, fn list ->
  #     list ++ [value]
  #   end))
  # end

  @doc """
  Add a new destination at the end of the destination list
  """
  def add_destination(bucket, value) do
    Agent.update(bucket, fn dict ->
      # If the destination exist already, don't do anything
      if Enum.member?(Map.get(dict, :destination), value) do
        dict
      else
        case Map.get(dict, :destination) do
          []            -> Map.update!(dict, :destination, fn _list -> [value] end)
          [head | tail] when dict[:current_position] ->
            Map.update!(dict, :destination, fn list -> list ++ [value] end)
        end
      end
    end)
  end

  @doc """
  remoove the first destination
  """
  def remoove_first_destination(bucket) do
    Agent.update(bucket, &Map.update!(&1, :destination, fn [head | tail] -> tail end))
  end
end
