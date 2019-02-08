defmodule Elevator.ElevatorCaller do
  use GenServer
  require Elevator.Constants
  alias Elevator.Constants, as: Const
  require Elevator.DirectionCalculator
  alias Elevator.DirectionCalculator, as: Direction

  ## Client API

  @doc """
  Starts the Genserver
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok)
  end

  @doc """
  Find and send an elevator to go to floor
  """
  def send_elevator_to(server, floor, direction, registry) do
    GenServer.cast(server, {:send_elevator, floor, direction, registry})
  end

  ## Server callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:send_elevator, floor, direction, registry}, _names) do
    # Special Case if we're going underground
    IO.puts 'IN SERVER'
    if floor == 0 and direction == Const.state_down do
      {:ok, elevator} = Elevator.ElevatorRegistry.lookup(registry, Const.elevator_1)
      Elevator.Elevator.add_destination(elevator, floor)
    else
      IO.puts 'IN SERVER 2'
      elevators = Elevator.ElevatorRegistry.index(registry)
      find_best(elevators, floor, direction, registry)
    end
    # Kill GenServer
    {:noreply, :ok}
  end

  def find_best(elevators, floor, direction, registry) do
    find = fn(array) ->
      if Enum.at(array, 0) == false do
        nil
      else
        Enum.at(array, 1)
      end
    end

    distances =  Map.new(elevators, fn {k, v} -> {k, Elevator.Elevator.get(v)} end)
    |> Map.new(fn {k, elev} ->
      {k, [Direction.come_to_my_direction?(direction, elev.state), abs(elev.current_position - floor)]}
    end)
    |> Enum.filter(fn {key, [head | _tail]} -> head end)
    |> Map.new(fn {key, array} -> {key, find.(array)} end)

    value = distances |> Map.values() |> Enum.sort() |> Enum.filter(& !is_nil(&1)) |> Enum.at(0)
    if value == nil do
      # wait and try again
    end
    key = distances |> Enum.find(fn {key, val} -> val == value end) |> elem(0)
    {:ok, elevator} = Elevator.ElevatorRegistry.lookup(registry, key)
    Elevator.Elevator.add_destination(elevator, floor)
  end

  # def intersting_values(elevator) do
  #   %{current_position: current_position, state: state} = Elevator.Elevator.get(elevator)
  # end
end
