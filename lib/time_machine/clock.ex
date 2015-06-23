defmodule TimeMachine.Clock do
  @default_clock []
  @default_time nil
  defstruct id: :random.uniform(999999999),
            time: @default_time,
            clock: @default_clock

  @doc """
  Starts a new clock.
  """
  def start_link(state, args \\ [])
  def start_link([], args)  do
    start_link [time: @default_time, clock: @default_clock], args
  end
  def start_link([time: time], args)  do
    start_link [time: time, clock: @default_clock], args
  end
  def start_link([time: time, clock: clock], args) do
    clock = %TimeMachine.Clock{time: time, clock: clock}
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
  Puts the `time` and `clock` for the given `clock`.
  """
  def put(pid, time: time, clock: clock) do
    Agent.update pid, fn(cstruct) ->
      %TimeMachine.Clock{ cstruct | time: time, clock: clock }
    end
  end
end
