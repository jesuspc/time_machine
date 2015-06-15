defmodule TimeMachine.Api.V1.ClocksView do
  use TimeMachine.Web, :view

  def render("show.json", %{clock: clock}) do
    %TimeMachine.Clock{ clock | clock: format_clock_list(clock.clock) }
  end

  defp format_clock_list([]) do
    "SYS (fakeable)"
  end
  defp format_clock_list(clock_list) do
    "FAKE #{clock_list}"
  end
end
