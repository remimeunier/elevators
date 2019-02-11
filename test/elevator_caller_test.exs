defmodule Elevator.ElevatorCallerTest do
  use ExUnit.Case, async: true
  require Elevator.Constants
  alias Elevator.Constants, as: Const

  setup do
    {:ok, moover1} = Elevator.ElevatorMoover.start_link(nil)
    elevator1 = Elevator.ElevatorMoover.create(moover1, "elevator_1", 2)
    {:ok, moover2} = Elevator.ElevatorMoover.start_link(nil)
    elevator2 = Elevator.ElevatorMoover.create(moover2, "elevator_2", 0)
    {:ok, moover3} = Elevator.ElevatorMoover.start_link(nil)
    elevator3 = Elevator.ElevatorMoover.create(moover3, "elevator_3", 6)

    # Save the elevator process inside a registry process
    {:ok, registry} = Elevator.ElevatorRegistry.start_link(nil)
    Elevator.ElevatorRegistry.load(registry, elevator1, 'elevator_1')
    Elevator.ElevatorRegistry.load(registry, elevator2, 'elevator_2')
    Elevator.ElevatorRegistry.load(registry, elevator3, 'elevator_3')
    caller = start_supervised!(Elevator.ElevatorCaller)
    %{caller: caller, registr: registry}
  end

  test "Should call elevator 1 to go underground", %{caller: caller, registr: registry} do
    Elevator.ElevatorCaller.send_elevator_to(caller, 0, -1, registry)
    Process.sleep(10)
    assert {:ok, elevator} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_1')

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 2,
             destination: [0],
             iddle_destination: [],
             state: Const.state_down(),
             display_name: "elevator_1"
           }
  end

  test "Should call elevator when caller underground", %{caller: caller, registr: registry} do
    Elevator.ElevatorCaller.send_elevator_to(caller, -2, 1, registry)
    Process.sleep(10)
    assert {:ok, elevator} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_1')

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 2,
             destination: [-2],
             iddle_destination: [],
             state: Const.state_down(),
             display_name: "elevator_1"
           }
  end

  test "Should call already present elevator", %{caller: caller, registr: registry} do
    Elevator.ElevatorCaller.send_elevator_to(caller, 0, 1, registry)
    Process.sleep(10)
    assert {:ok, elevator} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_2')

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 0,
             destination: [],
             iddle_destination: [],
             state: Const.state_idle(),
             display_name: "elevator_2"
           }
  end

  test "Should call closest when up of it", %{caller: caller, registr: registry} do
    Elevator.ElevatorCaller.send_elevator_to(caller, 7, 1, registry)
    Process.sleep(10)
    assert {:ok, elevator} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_3')

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 6,
             destination: [7],
             iddle_destination: [],
             state: Const.state_up(),
             display_name: "elevator_3"
           }
  end

  test "Should not call closest if already in used", %{caller: caller, registr: registry} do
    {:ok, elevator3} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_3')
    Elevator.Elevator.set_state(elevator3, -1)

    Elevator.ElevatorCaller.send_elevator_to(caller, 7, 1, registry)
    Process.sleep(10)
    assert {:ok, elevator} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_1')

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 2,
             destination: [7],
             iddle_destination: [],
             state: Const.state_up(),
             display_name: "elevator_1"
           }
  end

  test "when closest is same direction absolue but in front", %{caller: caller, registr: registry} do
    {:ok, elevator1} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_1')
    Elevator.Elevator.set_state(elevator1, -1)

    Elevator.ElevatorCaller.send_elevator_to(caller, 3, -1, registry)
    Process.sleep(10)
    assert {:ok, elevator} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_2')

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 0,
             destination: [3],
             iddle_destination: [],
             state: Const.state_up(),
             display_name: "elevator_2"
           }
  end

  test "if no elevator are available wait for them", %{caller: caller, registr: registry} do
    # Set elevator non available
    {:ok, elevator1} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_1')
    Elevator.Elevator.set_state(elevator1, 1)
    {:ok, elevator2} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_2')
    Elevator.Elevator.set_state(elevator2, -1)
    {:ok, elevator3} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_3')
    Elevator.Elevator.set_state(elevator3, 1)

    # call elevator for non available position
    Elevator.ElevatorCaller.send_elevator_to(caller, 1, -1, registry)
    Process.sleep(10)

    # Be sure that no elevator have the destination
    assert Elevator.Elevator.get(elevator1) == %{
             current_position: 2,
             destination: [],
             iddle_destination: [],
             state: Const.state_up(),
             display_name: "elevator_1"
           }

    assert Elevator.Elevator.get(elevator2) == %{
             current_position: 0,
             destination: [],
             iddle_destination: [],
             state: Const.state_down(),
             display_name: "elevator_2"
           }

    assert Elevator.Elevator.get(elevator3) == %{
             current_position: 6,
             destination: [],
             iddle_destination: [],
             state: Const.state_up(),
             display_name: "elevator_3"
           }

    # Change one elevator state
    Elevator.Elevator.set_state(elevator3, -1)
    # Sleep a little
    Process.sleep(1000)

    assert Elevator.Elevator.get(elevator3) == %{
             current_position: 6,
             destination: [1],
             iddle_destination: [],
             state: Const.state_down(),
             display_name: "elevator_3"
           }
  end
end
