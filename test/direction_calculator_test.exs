defmodule DirectionCalculatorTest do
  use ExUnit.Case, async: true

  test "test direction" do
    assert DirectionCalculator.direction(1, 3) == 1
    assert DirectionCalculator.direction(3, 1) == -1
    assert DirectionCalculator.direction(0, 0) == nil
  end

  test "test my_direction?" do
    assert DirectionCalculator.my_direction?(1, 3, -1) == true
    assert DirectionCalculator.my_direction?(1, 3, 1) == false
    assert DirectionCalculator.my_direction?(3, 1, -1) == false
    assert DirectionCalculator.my_direction?(3, 1, 1) == true
    assert DirectionCalculator.my_direction?(1, 1, nil) == true
    assert DirectionCalculator.my_direction?(1, 1, -1) == true
    assert DirectionCalculator.my_direction?(1, 1, 1) == true
  end
end
