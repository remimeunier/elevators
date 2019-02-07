defmodule Elevator.ElevatorBucketTest do
  use ExUnit.Case, async: true
  require MyConstants
  alias MyConstants, as: Const

  setup do
    {:ok, bucket} =  Elevator.ElevatorBucket.start_link(0)
    %{bucket: bucket}
  end

  test "Initialisation ", %{bucket: bucket} do
  assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 0,
                                                  destination: [],
                                                  iddle_destination: [],
                                                  state: Const.state_idle}
  end

  test "Adding/remooving destinations, state, and switch", %{bucket: bucket} do
    Elevator.ElevatorBucket.add_destination(bucket, 8)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 0,
                                                    destination: [8],
                                                    iddle_destination: [],
                                                    state: Const.state_idle}
    Elevator.ElevatorBucket.set_state(bucket, Const.state_up)
    Elevator.ElevatorBucket.add_destination(bucket, 6)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 0,
                                                    destination: [8, 6],
                                                    iddle_destination: [],
                                                    state: Const.state_up}
    Elevator.ElevatorBucket.add_destination(bucket, -1)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 0,
                                                    destination: [8, 6],
                                                    iddle_destination: [-1],
                                                    state: Const.state_up}
    Elevator.ElevatorBucket.remoove_destination(bucket, 8)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 0,
                                                    destination: [6],
                                                    iddle_destination: [-1],
                                                    state: Const.state_up}
    Elevator.ElevatorBucket.remoove_destination(bucket, 6)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 0,
                                                    destination: [-1],
                                                    iddle_destination: [],
                                                    state: Const.state_down}
  end

  test "Adding/remooving destinations, state, and switch 2", %{bucket: bucket} do
    Elevator.ElevatorBucket.add_destination(bucket, -1)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 0,
                                                    destination: [-1],
                                                    iddle_destination: [],
                                                    state: Const.state_idle}
    Elevator.ElevatorBucket.set_state(bucket, Const.state_down)
    Elevator.ElevatorBucket.add_destination(bucket, 6)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 0,
                                                    destination: [-1],
                                                    iddle_destination: [6],
                                                    state: Const.state_down}
    Elevator.ElevatorBucket.add_destination(bucket, -2)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 0,
                                                    destination: [-1, -2],
                                                    iddle_destination: [6],
                                                    state: Const.state_down}
    Elevator.ElevatorBucket.add_destination(bucket, 8)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 0,
                                                    destination: [-1, -2],
                                                    iddle_destination: [6, 8],
                                                    state: Const.state_down}
    Elevator.ElevatorBucket.remoove_destination(bucket, -1)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 0,
                                                    destination: [-2],
                                                    iddle_destination: [6, 8],
                                                    state: Const.state_down}
    Elevator.ElevatorBucket.remoove_destination(bucket, -2)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 0,
                                                    destination: [6, 8],
                                                    iddle_destination: [],
                                                    state: Const.state_up}
  end

  # test "Go up and down", %{bucket: bucket} do
  #   Elevator.ElevatorBucket.go_up(bucket)
  #   assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 1,
  #                                                   destination: [],
  #                                                   iddle_destination: [],
  #                                                   state: Const.state_idle}

  #   Elevator.ElevatorBucket.go_up(bucket)
  #   assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 2,
  #                                                   destination: [],
  #                                                   iddle_destination: [],
  #                                                   state: Const.state_idle}

  #   Elevator.ElevatorBucket.go_down(bucket)
  #   assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 1,
  #                                                   destination: [],
  #                                                   iddle_destination: [],
  #                                                   state: Const.state_idle}
  # end
end
