defmodule Elevator.ElevatorFinder do
  require Elevator.DirectionCalculator
  alias Elevator.DirectionCalculator, as: Direction

  def find_best(elevators, floor, direction, registry) do
    # Labda function use later on
    find = fn array ->
      if Enum.at(array, 0) == false do
        nil
      else
        Enum.at(array, 1)
      end
    end

    # Find relevant value to check if the elavators are available
    distances =
      Map.new(elevators, fn {k, v} -> {k, Elevator.Elevator.get(v)} end)
      |> Map.new(fn {k, elev} ->
        {k,
         [
           Direction.my_direction?(floor, direction, elev.current_position, elev.state),
           abs(elev.current_position - floor)
         ]}
      end)
      |> Enum.filter(fn {_tailkey, [head | _tail]} -> head end)
      |> Map.new(fn {key, array} -> {key, find.(array)} end)

    # Take the smalest
    value = distances |> Map.values() |> Enum.sort() |> Enum.filter(&(!is_nil(&1))) |> Enum.at(0)

    # If no elevators available, sleep a second and try again
    if value == nil do
      Process.sleep(1000)
      find_best(elevators, floor, direction, registry)
    end

    # If the smalest value exist, add destination to the elevator
    key = distances |> Enum.find(fn {_key, val} -> val == value end) |> elem(0)
    {:ok, elevator} = Elevator.ElevatorRegistry.lookup(registry, key)
    Elevator.Elevator.add_destination(elevator, floor)
  end
end
