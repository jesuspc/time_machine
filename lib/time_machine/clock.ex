defmodule TimeMachine.Clock do
  @default_clock []
  defstruct id: :random.uniform(999999999),
            clock: @default_clock

  @doc """
  Starts a new clock.
  """
  def start_link(clock, args \\ []) do
    clock = %TimeMachine.Clock{clock: clock}
    Agent.start_link(fn -> clock end, args)
  end

  @doc """
  Gets a value from the `clock` and reduces the counter automatically if needed.
  """
  def get(clock) do
    Agent.get_and_update clock, fn(cstruct) ->
      case cstruct.clock do
        [_|tail] -> { {:ok, cstruct}, %TimeMachine.Clock{ cstruct | clock: tail } }
        _        -> { {:ok, cstruct}, cstruct }
      end
    end
  end

  @doc """
  Puts the `clock` for the given `clock`.
  """
  def put(pid, clock: clock) do
    Agent.update pid, fn(cstruct) ->
      %TimeMachine.Clock{ cstruct | clock: clock }
    end
  end
end
