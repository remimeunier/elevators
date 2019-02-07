defmodule Elevator.ElevatorRegistry do
  use GenServer

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  create a bucket_elevator with the associated `name`, if it doesn't exist yet
  Returns `{:ok, bucket_pid}`
  """
  def create(server, name, initial_floor) do
    GenServer.call(server, {:create, name, initial_floor})
  end

  @doc """
  Looks up the bucket_elevator pid for `name` stored in `server`.
  Used for test debug and display
  Returns `{:ok, bucket_elevator_pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Moove the elevator `name` to `destination_floor`
  Returns `{:ok, bucket_pid}` if the bucket exists, `:error` otherwise.
  """
  def go_to(server, name, destination_floor) do
    GenServer.cast(server, {:go_to, name, destination_floor})
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, bucket_pid}` if the bucket exists, `:error` otherwise.
  """
  def exterior_call(server, floor, up_or_down) do
    # {:ok, elevator} = GenServer.call(server, {:find_best, floor, up_down})
    GenServer.cast(server, {:exterior_call, floor, up_or_down})
  end

  ## Server callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:create, name, initial_floor}, _from, names) do
  if Map.has_key?(names, name) do
      {:reply, Map.fetch(names, name), names}
    else
      {:ok, elevator_bucket} = Elevator.ElevatorBucket.start_link(initial_floor)
      names = Map.put(names, name, elevator_bucket)
      {:reply, Map.fetch(names, name), names}
    end
  end

  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  def handle_call({:exterior_call, floor, up_or_down}, _from, names) do

  end

  # def handle_cast({:go_to, name, destination_floor}, names) do
  #   {:ok, elevator} = Map.fetch(names, name)
  #   %{current_position: _current_position,
  #     destination: destination} = Elevator.ElevatorBucket.get(elevator)
  #   Elevator.ElevatorBucket.add_destination(elevator, destination_floor)
  #   if destination == [] do
  #     moove(Elevator.ElevatorBucket.get(elevator), elevator, name)
  #   end
  #   {:noreply, names}
  # end

  # defp moove(%{current_position: _current_position, destination: []}, _elevator, _name) do
  # end
  # defp moove(%{current_position: current_position,
  #              destination: [head | tail]}, elevator, name) do

  #   cond do
  #     current_position < head ->
  #       # moove from one up
  #       Process.sleep(1000)
  #       Elevator.ElevatorBucket.go_up(elevator)
  #     current_position > head ->
  #       # moove from one down
  #       Process.sleep(1000)
  #       Elevator.ElevatorBucket.go_down(elevator)
  #     end

  #   %{current_position: current_position,
  #     destination: [head | tail]} = Elevator.ElevatorBucket.get(elevator)
  #   if current_position == head do
  #     ColorPrinter.print("#{name} ARRIVED at floor #{head}", name)
  #     Elevator.ElevatorBucket.remoove_first_destination(elevator)
  #     Process.sleep(1000)
  #     moove(Elevator.ElevatorBucket.get(elevator), elevator, name)
  #   else
  #     ColorPrinter.print("#{name} Passed at floor #{current_position}", name)
  #     moove(%{current_position: current_position, destination: [head | tail]}, elevator, name)
  #   end
  # end
end
