defmodule Elevator.ElevatorCallerTest do
  use ExUnit.Case, async: true
  require Elevator.Constants
  alias Elevator.Constants, as: Const

  setup do
    {:ok, moover1} = Elevator.ElevatorMoover.start_link(nil)
    elevator1      = Elevator.ElevatorMoover.create(moover1, "elevator_1", 2)
    {:ok, moover2} = Elevator.ElevatorMoover.start_link(nil)
    elevator2      = Elevator.ElevatorMoover.create(moover2, "elevator_2", 0)
    {:ok, moover3} = Elevator.ElevatorMoover.start_link(nil)
    elevator3      = Elevator.ElevatorMoover.create(moover3, "elevator_3", 6)

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
    assert Elevator.Elevator.get(elevator) == %{current_position: 2,
                                                destination: [0],
                                                iddle_destination: [],
                                                state: Const.state_down,
                                                display_name: "elevator_1"}
  end

  test "Should call already present elevator", %{caller: caller, registr: registry} do
    Elevator.ElevatorCaller.send_elevator_to(caller, 0, 1, registry)
    Process.sleep(10)
    assert {:ok, elevator} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_2')
    assert Elevator.Elevator.get(elevator) == %{current_position: 0,
                                                destination: [],
                                                iddle_destination: [],
                                                state: Const.state_idle,
                                                display_name: "elevator_2"}
  end

  test "Should call closest when up of it", %{caller: caller, registr: registry} do
    Elevator.ElevatorCaller.send_elevator_to(caller, 7, 1, registry)
    Process.sleep(10)
    assert {:ok, elevator} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_3')
    assert Elevator.Elevator.get(elevator) == %{current_position: 6,
                                                destination: [7],
                                                iddle_destination: [],
                                                state: Const.state_up,
                                                display_name: "elevator_3"}
  end

  test "Should not call closest if already in used", %{caller: caller, registr: registry} do
    {:ok, elevator3} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_3')
    Elevator.Elevator.set_state(elevator3, -1)

    Elevator.ElevatorCaller.send_elevator_to(caller, 7, 1, registry)
    Process.sleep(10)
    assert {:ok, elevator} = Elevator.ElevatorRegistry.lookup(registry, 'elevator_1')
    assert Elevator.Elevator.get(elevator) == %{current_position: 2,
                                                destination: [7],
                                                iddle_destination: [],
                                                state: Const.state_up,
                                                display_name: "elevator_1"}
  end
end
