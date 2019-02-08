defmodule Elevator.ElevatorRegistry do
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
  Load the elevator inside the registry
  Returns `{:ok, bucket_pid}`
  """
  def load(server, elevator, name) do
    GenServer.call(server, {:load, elevator, name})
  end

  @doc """
  Looks up the elevator pid for `name` stored in `server`.
  Used for test debug and display
  Returns `{:ok, bucket_elevator_pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Looks up the bucket_elevator pid for `name` stored in `server`.
  Used for test debug and display
  Returns `{:ok, bucket_elevator_pid}` if the bucket exists, `:error` otherwise.
  """
  def index(server) do
    GenServer.call(server, {:index})
  end

  ## Server callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:load, elevator, name}, _from, names) do
  if Map.has_key?(names, name) do
      {:reply, Map.fetch(names, name), names}
    else
      names = Map.put(names, name, elevator)
      {:reply, Map.fetch(names, name), names}
    end
  end

  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  def handle_call({:index}, _from, names) do
    {:reply, names, names}
  end
end
