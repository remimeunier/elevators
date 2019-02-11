defmodule Elevator.ElevatorRegistryTest do
  use ExUnit.Case, async: true
  require Elevator.Constants
  alias Elevator.Constants, as: Const

  setup do
    registry = start_supervised!(Elevator.ElevatorRegistry)
    %{registry: registry}
  end

  test "the registry should keep the elevator associated to a name", %{registry: registry} do
    assert Elevator.ElevatorRegistry.lookup(registry, "elevator_1") == :error

    {:ok, elevator1} = Elevator.Elevator.start_link(0, 'elevator_1')
    Elevator.ElevatorRegistry.load(registry, elevator1, 'elevator_1')
    assert {:ok, elevator1} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_1')

    assert Elevator.Elevator.get(elevator1) == %{
             current_position: 0,
             destination: [],
             iddle_destination: [],
             state: Const.state_idle(),
             display_name: 'elevator_1'
           }

    {:ok, elevator2} = Elevator.Elevator.start_link(0, 'elevator_2')
    Elevator.ElevatorRegistry.load(registry, elevator2, 'elevator_2')
    assert {:ok, elevator2} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_2')

    assert Elevator.Elevator.get(elevator2) == %{
             current_position: 0,
             destination: [],
             iddle_destination: [],
             state: Const.state_idle(),
             display_name: 'elevator_2'
           }

    {:ok, elevator3} = Elevator.Elevator.start_link(6, 'elevator_3')
    Elevator.ElevatorRegistry.load(registry, elevator3, 'elevator_3')
    assert {:ok, elevator3} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_3')

    assert Elevator.Elevator.get(elevator3) == %{
             current_position: 6,
             destination: [],
             iddle_destination: [],
             state: Const.state_idle(),
             display_name: 'elevator_3'
           }

    assert Elevator.ElevatorRegistry.index(registry) == %{
             'elevator_1' => elevator1,
             'elevator_2' => elevator2,
             'elevator_3' => elevator3
           }
  end
end
