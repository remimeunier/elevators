defmodule DirectionCalculator do
  def direction(current_position, destination) do
    cond do
      current_position < destination -> 1 # for up
      current_position > destination -> -1 # for down
      current_position == destination -> nil
    end
  end

  def my_direction?(me, elevator, elevator_destination) do
    case elevator_destination do
      _ when me == elevator -> true
      1                     -> my_direction?(me, elevator)
      -1                    -> !my_direction?(me, elevator)
      nil                   -> true
    end
  end
  defp my_direction?(me, elevator) do
    case direction(me, elevator) do
      1  -> false
      -1 -> true
    end
  end
end
