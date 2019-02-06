defmodule Elevator.ElevatorBucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} =  Elevator.ElevatorBucket.start_link(0, [0, 3, 4, 5, 6, 7, 8, 9])
    %{bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 0,
                                                    destination: [],
                                                    floor_stops: [0, 3, 4, 5, 6, 7, 8, 9]}

    Elevator.ElevatorBucket.add_destination(bucket, 8)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 0,
                                                    destination: [8],
                                                    floor_stops: [0, 3, 4, 5, 6, 7, 8, 9]}

    Elevator.ElevatorBucket.go_up(bucket)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 1,
                                                    destination: [8],
                                                    floor_stops: [0, 3, 4, 5, 6, 7, 8, 9]}

    Elevator.ElevatorBucket.go_up(bucket)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 2,
                                                    destination: [8],
                                                    floor_stops: [0, 3, 4, 5, 6, 7, 8, 9]}

    Elevator.ElevatorBucket.go_down(bucket)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 1,
                                                    destination: [8],
                                                    floor_stops: [0, 3, 4, 5, 6, 7, 8, 9]}


    Elevator.ElevatorBucket.add_destination(bucket, 9)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 1,
                                                    destination: [8, 9],
                                                    floor_stops: [0, 3, 4, 5, 6, 7, 8, 9]}

    Elevator.ElevatorBucket.remoove_first_destination(bucket)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 1,
                                                    destination: [9],
                                                    floor_stops: [0, 3, 4, 5, 6, 7, 8, 9]}

    Elevator.ElevatorBucket.remoove_first_destination(bucket)
    assert Elevator.ElevatorBucket.get(bucket) == %{current_position: 1,
                                                    destination: [],
                                                    floor_stops: [0, 3, 4, 5, 6, 7, 8, 9]}
  end
end
