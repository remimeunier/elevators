defmodule Elevator.Elevator do
  use Agent
  require Elevator.Constants
  alias Elevator.Constants, as: Const

  @doc """
  Starts a new elevator.
  """
  def start_link(initial_floor, name) do
    Agent.start_link(fn ->
      %{
        current_position: initial_floor,
        destination: [],
        iddle_destination: [],
        state: Const.state_idle(),
        display_name: name
      }
    end)
  end

  @doc """
  Gets a value from the `elevator` by `key`.
  """
  def get(elevator) do
    Agent.get(elevator, fn list -> list end)
  end

  @doc """
  add 1 to current_position.
  """
  def go_up(elevator) do
    Agent.update(elevator, &Map.update!(&1, :current_position, fn value -> value + 1 end))
  end

  @doc """
  Substract 1 to current_position.
  """
  def go_down(elevator) do
    Agent.update(elevator, &Map.update!(&1, :current_position, fn value -> value - 1 end))
  end

  @doc """
  Substract 1 to current_position.
  """
  def set_state(elevator, state) do
    Agent.update(elevator, &Map.update!(&1, :state, fn _value -> state end))
  end

  @doc """
  Add a new destination accordinly to our logic (see choice maker file)
  """
  def add_destination(elevator, destination) do
    Agent.update(elevator, fn dict ->
      Elevator.DestinationStrategy.add_destination_to_elevator(dict, destination)
    end)
  end

  @doc """
  Remoove destination accordinly to our logic (see choice maker file)
  """
  def remoove_destination(elevator, destination) do
    Agent.update(elevator, fn dict ->
      Elevator.DestinationStrategy.remove_destination_to_elevator(dict, destination)
    end)
  end
end
