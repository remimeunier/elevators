defmodule Elevator.Elevator do
  use Agent
  require Elevator.Constants
  alias Elevator.Constants, as: Const

  @doc """
  Starts a new bucket.
  """
  def start_link(initial_floor, name) do
    Agent.start_link(fn -> %{current_position: initial_floor,
                             destination: [],
                             iddle_destination: [],
                             state: Const.state_idle,
                             display_name: name} end)
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
  Substract 1 to current_position.
  """
  def set_state(bucket, state) do
    Agent.update(bucket, &Map.update!(&1, :state, fn _value -> state end))
  end

  @doc """
  Add a new destination accordinly to our logic (see choice maker file)
  """
  def add_destination(bucket, destination) do
    Agent.update(bucket, fn dict ->
      Elevator.ChoiceMaker.add_destination_to_elevator(dict, destination)
    end)
  end

  @doc """
  Remoove destination accordinly to our logic (see choice maker file)
  """
  def remoove_destination(bucket, destination) do
    Agent.update(bucket, fn dict ->
      Elevator.ChoiceMaker.remove_destination_to_elevator(dict, destination)
    end)
  end
end
