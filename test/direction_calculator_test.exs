defmodule DirectionCalculatorTest do
  use ExUnit.Case, async: true
  require Elevator.Constants
  alias Elevator.Constants, as: Const

  test "test direction" do
    assert Elevator.DirectionCalculator.direction(1, 3) == 1
    assert Elevator.DirectionCalculator.direction(3, 1) == -1
    assert Elevator.DirectionCalculator.direction(0, 0) == 0
  end

  test "test my_direction?" do
    # case elevator idle
    assert Elevator.DirectionCalculator.my_direction?(
             1,
             Const.state_down(),
             0,
             Const.state_idle()
           ) == true

    assert Elevator.DirectionCalculator.my_direction?(
             0,
             Const.state_down(),
             1,
             Const.state_idle()
           ) == true

    assert Elevator.DirectionCalculator.my_direction?(1, Const.state_up(), 0, Const.state_idle()) ==
             true

    assert Elevator.DirectionCalculator.my_direction?(0, Const.state_up(), 1, Const.state_idle()) ==
             true

    # case Same floor
    assert Elevator.DirectionCalculator.my_direction?(1, Const.state_up(), 1, Const.state_up()) ==
             true

    assert Elevator.DirectionCalculator.my_direction?(1, Const.state_up(), 1, Const.state_down()) ==
             true

    assert Elevator.DirectionCalculator.my_direction?(1, Const.state_down(), 1, Const.state_up()) ==
             true

    assert Elevator.DirectionCalculator.my_direction?(
             1,
             Const.state_down(),
             1,
             Const.state_down()
           ) == true

    # complictaed cased
    assert Elevator.DirectionCalculator.my_direction?(0, Const.state_up(), 1, Const.state_up()) ==
             false

    assert Elevator.DirectionCalculator.my_direction?(0, Const.state_up(), 1, Const.state_down()) ==
             false

    assert Elevator.DirectionCalculator.my_direction?(
             0,
             Const.state_down(),
             1,
             Const.state_down()
           ) == true

    assert Elevator.DirectionCalculator.my_direction?(1, Const.state_up(), 0, Const.state_up()) ==
             true

    assert Elevator.DirectionCalculator.my_direction?(1, Const.state_up(), 0, Const.state_down()) ==
             false

    assert Elevator.DirectionCalculator.my_direction?(
             1,
             Const.state_down(),
             0,
             Const.state_down()
           ) == false
  end
end
