defmodule Elevator.DirectionCalculator do
  require Elevator.Constants
  alias Elevator.Constants, as: Const

  def direction(current_position, destination) do
    cond do
      current_position < destination  -> Const.state_up
      current_position > destination  -> Const.state_down
      current_position == destination -> Const.state_idle
    end
  end

  def come_to_my_direction?(my_direction, Const.state_idle) do
    true
  end
  def come_to_my_direction?(my_direction, elevator_direction) do
    my_direction == elevator_direction
  end

  def my_direction?(my_position, elevator_elevator, elevator_destination) do
    # case elevator_destination do
    #   _ when my_position == elevator -> true
    #   Const.state_up        -> my_direction?(me, elevator)
    #   Const.state_down      -> !my_direction?(me, elevator)
    #   Const.state_idle      -> true
    # end
  end
  defp my_direction?(me, elevator) do
    case direction(me, elevator) do
      Const.state_up   -> false
      Const.state_down -> true
    end
  end
end
