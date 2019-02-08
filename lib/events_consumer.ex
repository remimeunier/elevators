defmodule Elevator.EventsConsumer do

  @moduledoc """
  Define the user action
  """

  def init do
    # create the elevators and moover process
    {:ok, moover1} = Elevator.ElevatorMoover.start_link(nil)
    elevator1      = Elevator.ElevatorMoover.create(moover1, "elevator_1", 0)
    {:ok, moover2} = Elevator.ElevatorMoover.start_link(nil)
    elevator2      = Elevator.ElevatorMoover.create(moover2, "elevator_2", 0)
    {:ok, moover3} = Elevator.ElevatorMoover.start_link(nil)
    elevator3      = Elevator.ElevatorMoover.create(moover3, "elevator_3", 6)

    # Save the elevator process inside a registry process
    {:ok, registry} = Elevator.ElevatorRegistry.start_link(nil)
    Elevator.ElevatorRegistry.load(registry, elevator1, 'elevator_1')
    Elevator.ElevatorRegistry.load(registry, elevator2, 'elevator_2')
    Elevator.ElevatorRegistry.load(registry, elevator3, 'elevator_3')

    {:ok, elevator_caller} = Elevator.ElevatorCaller.start_link(nil)
    # Elevator.ElevatorCaller.send_elevator_to(elevator_caller, floor, direction, registry)
    Elevator.ElevatorCaller.send_elevator_to(elevator_caller, 5, -1, registry)

    # Start the mooving process
    Elevator.ElevatorMoover.start(moover1, elevator1)
    Elevator.ElevatorMoover.start(moover2, elevator2)
    Elevator.ElevatorMoover.start(moover3, elevator3)

    # return registry
    {:ok, registry}
  end


  def event({:exterior_call, floor, direction}, registry) do
    {:ok, elevator_caller} = Elevator.ElevatorCaller.start_link(nil)
    # Elevator.ElevatorCaller.send_elevator_to(elevator_caller, floor, direction, registry)
    Elevator.ElevatorCaller.send_elevator_to(elevator_caller, 5, -1, registry)
  end
  def event({:interior_call, elevator_name, destination_floor}, registry) do
    {:ok, elevator}  = Elevator.ElevatorRegistry.lookup(registry, elevator_name)
    Elevator.Elevator.add_destination(elevator, destination_floor)
  end

  def event({:open_door, elevator_name}, registry) do
  end
  def event({:close_door, elevator_name}, registry) do
  end
end
