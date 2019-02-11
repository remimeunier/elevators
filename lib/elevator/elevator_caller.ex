defmodule Elevator.ElevatorCaller do
  use GenServer
  require Elevator.Constants
  alias Elevator.Constants, as: Const

  ## Client API

  @doc """
  Starts the Genserver
  """
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok)
  end

  @doc """
  Find and send an elevator to go to floor
  """
  def send_elevator_to(server, floor, direction, registry) do
    GenServer.cast(server, {:send_elevator, floor, direction, registry})
  end

  ## Server callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:send_elevator, floor, direction, registry}, names) do
    # Special Case if we're going underground
    if (floor == 0 and direction == Const.state_down) or Enum.member?([-1, -2], floor) do
      {:ok, elevator} = Elevator.ElevatorRegistry.lookup(registry, Const.elevator_1)
      Elevator.Elevator.add_destination(elevator, floor)
    else
      elevators = Elevator.ElevatorRegistry.index(registry)
      Elevator.ElevatorFinder.find_best(elevators, floor, direction, registry)
    end
    {:noreply, names}
  end
end
