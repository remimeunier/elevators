defmodule Elevator.ElevatorMoover do
  use GenServer
  require Elevator.Constants
  alias Elevator.Constants, as: Const

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok)
  end

  @doc """
  create a bucket_elevator with the associated `name`, if it doesn't exist yet
  Returns `{:ok, bucket_pid}`
  """
  def create(server, initial_floor, name) do
    GenServer.call(server, {:create, initial_floor, name})
  end

  @doc """
  Start worker who handler the mooving
  Returns `{:ok, bucket_pid}`
  """
  def start(server, elevator) do
    GenServer.cast(server, {:moove, elevator})
  end

  ## Server callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:create, initial_floor, name}, _from, _names) do
    {:ok, elevator} = Elevator.Elevator.start_link(name, initial_floor)
    {:reply, elevator, _names}
  end

  def handle_cast({:moove, elevator}, names) do
    moove(Elevator.Elevator.get(elevator), elevator)
    {:noreply, names}
  end

  # Don't moove if not needed
  defp moove(%{state: Const.state_idle, display_name: name}, elevator) do
    Process.sleep(1000)
    ColorPrinter.print("#{name} iddle, wait", name)
    moove(Elevator.Elevator.get(elevator), elevator)
  end
  # moove from one up
  defp moove(%{current_position: current_position,
               state: Const.state_up,
               destination: dest,
               display_name: name }, elevator) do
    Process.sleep(1000)
    Elevator.Elevator.go_up(elevator)
    arrived(current_position + 1 , dest, elevator, name)
  end
  # moove from one down
  defp moove(%{current_position: current_position,
               state: Const.state_down,
               destination: dest,
               display_name: name }, elevator) do
    Process.sleep(1000)
    Elevator.Elevator.go_down(elevator)
    arrived(current_position - 1, dest, elevator, name)
  end

  defp arrived(new_position, dest, elevator, name) do
    if Enum.member?(dest, new_position) do
      ColorPrinter.print("#{name} ARRIVED at floor #{new_position}", name)
      Elevator.Elevator.remoove_destination(elevator, new_position)
      Process.sleep(1000)
      moove(Elevator.Elevator.get(elevator), elevator)
    else
      ColorPrinter.print("#{name} Passed by floor #{new_position}", name)
    end
    moove(Elevator.Elevator.get(elevator), elevator)
  end
end
