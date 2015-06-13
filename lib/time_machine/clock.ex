defmodule TimeMachine.Clock do
  @default_clock "SYS (fakeable)"
  use Timex
  defstruct id: :random.uniform(999999999),
            time: nil,
            clock: @default_clock

  @doc """
  Starts a new clock.
  """
  def start_link(time: time)  do
    start_link time: time, clock: @default_clock
  end
  def start_link(time: time, clock: clock) do
    clock = %TimeMachine.Clock{time: time, clock: clock}
    Agent.start_link(fn -> clock end)
  end

  @doc """
  Gets a value from the `clock` and reduces the counter automatically if needed.
  """
  def get(clock) do
    case fetch(clock) do
      {:ok, val}    -> val
      {:empty, val} -> Agent.stop(clock) && val
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

  defp fetch(clock) do
    Agent.get_and_update clock, fn(cstruct) ->
      case cstruct.clock do
        [last]   -> { {:empty, cstruct}, %TimeMachine.Clock{ cstruct | clock: [] } }
        [_|tail] -> { {:ok, cstruct}, %TimeMachine.Clock{ cstruct | clock: tail } }
        _     -> { {:ok, cstruct}, cstruct }
      end
    end
  end

  defp time_formatter do
    &(DateFormat.format! &1, "{ISOz}")
  end
end
