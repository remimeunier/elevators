defmodule Elevator.ElevatorRegistryTest do
  use ExUnit.Case, async: true
  require MyConstants
  alias MyConstants, as: Const

  setup do
    registry = start_supervised!(Elevator.ElevatorRegistry)
    %{registry: registry}
  end

  # test "spawns 3 elevators buckets", %{registry: registry} do
  #   assert Elevator.ElevatorRegistry.lookup(registry, "elevator_1") == :error

  #   Elevator.ElevatorRegistry.create(registry, "elevator_1", 0)
  #   assert {:ok, bucket} = Elevator.ElevatorRegistry.lookup(registry, "elevator_1")
  #   assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 0,
  #                                                   destination: [],
  #                                                   iddle_destination: [],
  #                                                   state: Const.state_idle}

  #   Elevator.ElevatorRegistry.create(registry, "elevator_2", 0)
  #   assert {:ok, bucket} = Elevator.ElevatorRegistry.lookup(registry, "elevator_2")
  #   assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 0,
  #                                                   destination: [],
  #                                                   iddle_destination: [],
  #                                                   state: Const.state_idle}

  #   Elevator.ElevatorRegistry.create(registry, "elevator_3", 6)
  #   assert {:ok, bucket} = Elevator.ElevatorRegistry.lookup(registry, "elevator_3")
  #   assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 6,
  #                                                   destination: [],
  #                                                   iddle_destination: [],
  #                                                   state: Const.state_idle}
  # end

  # test "elevator go_to up change the destination", %{registry: registry} do
  #   Elevator.ElevatorRegistry.create(registry, "elevator_1", 0)
  #   Elevator.ElevatorRegistry.go_to(registry, "elevator_1", 1)
  #   Elevator.ElevatorRegistry.go_to(registry, "elevator_1", 2)
  #   assert {:ok, bucket} = Elevator.ElevatorRegistry.lookup(registry, "elevator_1")
  #   assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 2,
  #                                                   destination: [],
  #                                                   floor_stops: [0, 1, 2]}

  # end

#   test "elevator go_to down change the destination", %{registry: registry} do
#     Elevator.ElevatorRegistry.create(registry, "elevator_1", 3, [0, 1, 2])
#     Elevator.ElevatorRegistry.go_to(registry, "elevator_1", 2)
#     Elevator.ElevatorRegistry.go_to(registry, "elevator_1", 1)
#     assert {:ok, bucket} = Elevator.ElevatorRegistry.lookup(registry, "elevator_1")
#     assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 1,
#                                                     destination: [],
#                                                     floor_stops: [0, 1, 2]}

#   end
#   test "elevator go_to up down and down change the destination", %{registry: registry} do
#     Elevator.ElevatorRegistry.create(registry, "elevator_1", 0, [0, 1, 2])
#     Elevator.ElevatorRegistry.go_to(registry, "elevator_1", 2)
#     Elevator.ElevatorRegistry.go_to(registry, "elevator_1", 1)
#     :timer.sleep(1000)
#     assert {:ok, bucket} = Elevator.ElevatorRegistry.lookup(registry, "elevator_1")
#     assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 1,
#                                                     destination: [],
#                                                     floor_stops: [0, 1, 2]}

#   end
end
