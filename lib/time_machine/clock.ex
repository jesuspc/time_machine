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
    map = Map.from_struct(clock)
    # For some reason it is sending the struct as a keyword list
    Agent.start_link(fn -> map end)
  end

  @doc """
  Gets a value from the `clock` and reduces the counter automatically if needed.
  """
  def get(clock) do
    case fetch(clock) do
      {:ok, val}    -> struct(TimeMachine.Clock, val)
      {:empty, val} -> Agent.stop(clock) && struct(TimeMachine.Clock, val)
    end
  end

  @doc """
  Puts the `time` and `clock` for the given `clock`.
  """
  def put(clock, %{time: time, clock: clock}) do
    Agent.update clock, fn(cstruct) ->
      %{ cstruct | time: time, clock: clock }
    end
  end

  defp fetch(clock) do
    Agent.get_and_update clock, fn(cstruct) ->
      case cstruct.clock do
        [last]   -> { {:empty, cstruct}, %{ cstruct | clock: [] } }
        [_|tail] -> { {:ok, cstruct}, %{ cstruct | clock: tail } }
        _     -> { {:ok, cstruct}, cstruct }
      end
    end
  end

  defp time_formatter do
    &(DateFormat.format! &1, "{ISOz}")
  end
end
