defmodule TimeMachine.Registry do
  use GenServer

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(opts \\ [{:name, __MODULE__}]) do
    {:ok, server} = GenServer.start_link(__MODULE__, :ok, opts)
    {create(server, :default), server}
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

  def handle_cast({:create, :default, _}, idens) do
    if HashDict.has_key?(idens, :default) do
      {:noreply, idens}
    else
      {:ok, clock} = TimeMachine.Clock.start_link([], name: :default)
      {:noreply, HashDict.put(idens, :default, clock)}
    end
  end
  def handle_cast({:create, iden, initialization_args}, idens) do
    if HashDict.has_key?(idens, iden) do
      {:noreply, idens}
    else
      {:ok, clock} = TimeMachine.Clock.start_link(initialization_args)
      {:noreply, HashDict.put(idens, iden, clock)}
    end
  end

  defp time_formatter do
    &(DateFormat.format! &1, "{ISOz}")
  end

end
