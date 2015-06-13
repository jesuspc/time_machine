defmodule TimeMachine.Api.V1.ClocksView do
  use TimeMachine.Web, :view

  def render("show.json", %{clock: clock}) do
    clock
  end
end
