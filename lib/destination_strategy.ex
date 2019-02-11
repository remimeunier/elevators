defmodule Elevator.DestinationStrategy do
  require Elevator.Constants
  alias Elevator.Constants, as: Const

  ## Add destination logic

  def add_destination_to_elevator(elevator_dict, destination) do
    current_position = Map.get(elevator_dict, :current_position)

    if current_position == destination or
         Enum.member?(Map.get(elevator_dict, :destination), destination) or
         Enum.member?(Map.get(elevator_dict, :iddle_destination), destination) do
      elevator_dict
    else
      add_by_direction(
        Map.get(elevator_dict, :state),
        elevator_dict,
        destination,
        current_position
      )
    end
  end

  defp add_by_direction(Const.state_idle(), elevator_dict, destination, current_position) do
    Map.update!(elevator_dict, :destination, fn list -> list ++ [destination] end)
    |> Map.update!(:state, fn _elem ->
      Elevator.DirectionCalculator.direction(current_position, destination)
    end)
  end

  defp add_by_direction(Const.state_up(), elevator_dict, destination, current_position) do
    case current_position < destination do
      true ->
        Map.update!(elevator_dict, :destination, fn list -> list ++ [destination] end)

      false ->
        Map.update!(elevator_dict, :iddle_destination, fn list -> list ++ [destination] end)
    end
  end

  defp add_by_direction(Const.state_down(), elevator_dict, destination, current_position) do
    case current_position < destination do
      false -> Map.update!(elevator_dict, :destination, fn list -> list ++ [destination] end)
      true -> Map.update!(elevator_dict, :iddle_destination, fn list -> list ++ [destination] end)
    end
  end

  ## Remove destination logic

  def remove_destination_to_elevator(elevator_dict, destination) do
    # remoove destination
    new_value =
      Map.update!(elevator_dict, :destination, fn list ->
        Enum.filter(list, fn el -> el != destination end)
      end)

    case new_value do
      %{destination: [], iddle_destination: []} ->
        Map.update!(new_value, :state, fn _elem -> Const.state_idle() end)

      %{destination: []} ->
        Map.update!(new_value, :destination, fn _list ->
          Map.get(new_value, :iddle_destination)
        end)
        |> Map.update!(:iddle_destination, fn _list -> [] end)
        |> Map.update!(:state, fn elem -> elem * -1 end)

      _ ->
        new_value
    end
  end
end
