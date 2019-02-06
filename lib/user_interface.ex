defmodule Elevator.UserInterface do

  @moduledoc """
  Define the user action
  """

  def init do
    p1 = [-1, -2, 0, 3, 4, 5, 6, 7, 8, 9]
    p2 = [0, 3, 4, 5, 6, 7, 8, 9]
    {:ok, registry} = Elevator.ElevatorRegistry.start_link(nil)
    Elevator.ElevatorRegistry.create(registry, "elevator_1", 0, p1)
    Elevator.ElevatorRegistry.create(registry, "elevator_2", 0, p2)
    Elevator.ElevatorRegistry.create(registry, "elevator_3", 6, p2)
    registry
  end

  # def exterior_call_up(registry, floor) do
  #   # bring best elevator to floor
  # end

  # def exterior_call_down(registry, floor) do
  #   # bring best elevator to floor
  # end

  def interior_call(registry, elevator_name, destination_floor) do
    Elevator.ElevatorRegistry.go_to(registry, elevator_name, destination_floor)
  end

  def block_elevator(registry, elevator_name) do

  end
end
