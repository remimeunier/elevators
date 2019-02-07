defmodule Elevator.ChoiceMaker do
  require MyConstants
  alias MyConstants, as: Const
  # def find_best(names, current_floor, up_or_down) do
  #   # Only elevator 1 can go underground
  #   if current_floor == 0 and up_or_down == Elevator.consts[:STATE_DOWN] do
  #     Map.fetch(names, 'elevator1')
  #   end

  # end

  # # if idle return the distance
  # def distance(%{current_position: current_position, state: 0}, floor) do
  #   current_position - floor
  # end

  def add_destination_to_elevator(elevator_dict, destination) do
    current_position = Map.get(elevator_dict, :current_position)
    if current_position == destination or
       Enum.member?(Map.get(elevator_dict, :destination), destination) or
       Enum.member?(Map.get(elevator_dict, :iddle_destination), destination) do
      elevator_dict
    else
      add_by_direction(Map.get(elevator_dict, :state), elevator_dict, destination, current_position)
    end
  end

  defp add_by_direction(Const.state_idle, elevator_dict, destination, current_position) do
    Map.update!(elevator_dict, :destination, fn list ->list ++ [destination] end)
  end
  defp add_by_direction(Const.state_up, elevator_dict, destination, current_position) do
    case current_position < destination do
      true -> Map.update!(elevator_dict, :destination, fn list ->list ++ [destination] end)
      false -> Map.update!(elevator_dict, :iddle_destination, fn list ->list ++ [destination] end)
    end
  end
  defp add_by_direction(Const.state_down, elevator_dict, destination, current_position) do
    case current_position < destination do
      false -> Map.update!(elevator_dict, :destination, fn list ->list ++ [destination] end)
      true -> Map.update!(elevator_dict, :iddle_destination, fn list ->list ++ [destination] end)
    end
  end
end
