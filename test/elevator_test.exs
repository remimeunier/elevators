defmodule Elevator.ElevatorTest do
  use ExUnit.Case, async: true
  require Elevator.Constants
  alias Elevator.Constants, as: Const

  setup do
    {:ok, elevator} = Elevator.Elevator.start_link(0, 'elevator1')
    %{elevator: elevator}
  end

  test "Initialisation ", %{elevator: elevator} do
    assert Elevator.Elevator.get(elevator) == %{
             current_position: 0,
             destination: [],
             iddle_destination: [],
             state: Const.state_idle(),
             display_name: 'elevator1'
           }
  end

  test "Adding/remooving destinations, state, and switch", %{elevator: elevator} do
    Elevator.Elevator.add_destination(elevator, 8)

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 0,
             destination: [8],
             iddle_destination: [],
             state: Const.state_up(),
             display_name: 'elevator1'
           }

    Elevator.Elevator.add_destination(elevator, 6)

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 0,
             destination: [8, 6],
             iddle_destination: [],
             state: Const.state_up(),
             display_name: 'elevator1'
           }

    Elevator.Elevator.add_destination(elevator, -1)

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 0,
             destination: [8, 6],
             iddle_destination: [-1],
             state: Const.state_up(),
             display_name: 'elevator1'
           }

    Elevator.Elevator.remoove_destination(elevator, 8)

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 0,
             destination: [6],
             iddle_destination: [-1],
             state: Const.state_up(),
             display_name: 'elevator1'
           }

    Elevator.Elevator.remoove_destination(elevator, 6)

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 0,
             destination: [-1],
             iddle_destination: [],
             state: Const.state_down(),
             display_name: 'elevator1'
           }

    Elevator.Elevator.remoove_destination(elevator, -1)

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 0,
             destination: [],
             iddle_destination: [],
             state: Const.state_idle(),
             display_name: 'elevator1'
           }
  end

  test "Adding/remooving destinations, state, and switch 2", %{elevator: elevator} do
    Elevator.Elevator.add_destination(elevator, -1)

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 0,
             destination: [-1],
             iddle_destination: [],
             state: Const.state_down(),
             display_name: 'elevator1'
           }

    Elevator.Elevator.add_destination(elevator, 6)

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 0,
             destination: [-1],
             iddle_destination: [6],
             state: Const.state_down(),
             display_name: 'elevator1'
           }

    Elevator.Elevator.add_destination(elevator, -2)

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 0,
             destination: [-1, -2],
             iddle_destination: [6],
             state: Const.state_down(),
             display_name: 'elevator1'
           }

    Elevator.Elevator.add_destination(elevator, 8)

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 0,
             destination: [-1, -2],
             iddle_destination: [6, 8],
             state: Const.state_down(),
             display_name: 'elevator1'
           }

    Elevator.Elevator.remoove_destination(elevator, -1)

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 0,
             destination: [-2],
             iddle_destination: [6, 8],
             state: Const.state_down(),
             display_name: 'elevator1'
           }

    Elevator.Elevator.remoove_destination(elevator, -2)

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 0,
             destination: [6, 8],
             iddle_destination: [],
             state: Const.state_up(),
             display_name: 'elevator1'
           }

    Elevator.Elevator.remoove_destination(elevator, 6)
    Elevator.Elevator.remoove_destination(elevator, 8)

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 0,
             destination: [],
             iddle_destination: [],
             state: Const.state_idle(),
             display_name: 'elevator1'
           }
  end

  test "Go up and down", %{elevator: elevator} do
    Elevator.Elevator.go_up(elevator)

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 1,
             destination: [],
             iddle_destination: [],
             state: Const.state_idle(),
             display_name: 'elevator1'
           }

    Elevator.Elevator.go_up(elevator)

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 2,
             destination: [],
             iddle_destination: [],
             state: Const.state_idle(),
             display_name: 'elevator1'
           }

    Elevator.Elevator.go_down(elevator)

    assert Elevator.Elevator.get(elevator) == %{
             current_position: 1,
             destination: [],
             iddle_destination: [],
             state: Const.state_idle(),
             display_name: 'elevator1'
           }
  end
end
