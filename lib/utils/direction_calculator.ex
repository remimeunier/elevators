defmodule Elevator.DirectionCalculator do
  require Elevator.Constants
  alias Elevator.Constants, as: Const

  def direction(current_position, destination) do
    cond do
      current_position < destination -> Const.state_up()
      current_position > destination -> Const.state_down()
      current_position == destination -> Const.state_idle()
    end
  end

  def my_direction?(_my_position, _my_destination, _elevator_position, Const.state_idle()) do
    true
  end

  def my_direction?(my_position, my_destination, elevator_position, elevator_destination) do
    if my_position == elevator_position do
      true
    else
      case my_destination == elevator_destination do
        true when my_destination == 1 -> my_direction?(my_position, elevator_position)
        true when my_destination == -1 -> !my_direction?(my_position, elevator_position)
        false -> false
      end
    end
  end

  defp my_direction?(me, elevator) do
    case direction(me, elevator) do
      Const.state_up() -> false
      Const.state_down() -> true
    end
  end
end
