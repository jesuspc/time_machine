defmodule TimeMachine.Api.V1.ClocksView do
  use TimeMachine.Web, :view
  use Timex

  def render("show.json", %{clock: clock}) do
    formatted_clock = %{ Map.from_struct(clock) | clock: format_clock_list(clock.clock) }
    Dict.put formatted_clock, :time, format_time(clock.clock)
  end

  def render("create.json", _) do
    %{}
  end

  defp format_clock_list([]) do
    "SYS (fakeable)"
  end
  defp format_clock_list(clock_list) do
    as_string = Enum.join clock_list, ", "
    "FAKE [#{as_string}]"
  end

  defp format_time([]) do
    format_time Date.now
  end
  defp format_time([hd|_]) when is_integer(hd) do
    hd |> Date.from(:secs) |> format_time
  end
  defp format_time([hd|_]) do
    DateFormat.format! hd, "{ISOz}"
  end
  defp format_time(time) do
    DateFormat.format! time, "{ISOz}"
  end
end
