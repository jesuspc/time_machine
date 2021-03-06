defmodule TimeMachine.Registry do
  use GenServer

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(opts \\ [{:name, __MODULE__}]) do
    case GenServer.start_link(__MODULE__, :ok, opts) do
      {:ok, server} -> {create(server, :default), server}
      any -> any
    end
  end

  @doc """
  Looks up the pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the clock exists, `:error` otherwise.
  """
  def lookup(server, iden) do
    GenServer.call(server, {:lookup, iden})
  end

  @doc """
  Ensures there is a clock associated to the given `iden` in `server`.
  """
  def create(server, iden, initialization_args \\ []) do
    GenServer.cast(server, {:create, iden, initialization_args})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, HashDict.new}
  end

  def handle_call({:lookup, iden}, _from, idens) do
    {:reply, HashDict.fetch(idens, iden), idens}
  end

  def handle_cast({:create, iden, initialization_args}, idens) do
    if HashDict.has_key?(idens, iden) do
      TimeMachine.Clock.put(HashDict.get(idens, iden), initialization_args)
      {:noreply, idens}
    else
      {:ok, clock} = TimeMachine.Clock.start_link(initialization_args)
      {:noreply, HashDict.put(idens, iden, clock)}
    end
  end
  def handle_cast(:stop, state) do
    {:noreply, state}
  end
end
