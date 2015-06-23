defmodule TimeMachine.Api.V1.ClocksView do
  use TimeMachine.Web, :view
  use Timex

  def render("show.json", %{clock: clock}) do
    %TimeMachine.Clock{ clock | clock: format_clock_list(clock.clock), time: format_time(clock.time) }
  end

  defp format_clock_list([]) do
    "SYS (fakeable)"
  end
  defp format_clock_list(clock_list) do
    "FAKE #{clock_list}"
  end

  defp format_time(nil) do
    format_time Date.now
  end
  defp format_time(time) do
    DateFormat.format! time, "{ISOz}"
  end
end
