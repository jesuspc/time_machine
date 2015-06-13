defmodule TimeMachine.Api.V1.ClocksController do
  use Phoenix.Controller

  plug :action

  def show(conn, params) do
    render conn, clock: clock(params)
  end

  def create(conn, params) do

  end

  defp clock(params) do
    #params |> id_from_params |> get_clock
  end

  defp get_clock(id) do

  end

  defp id_from_params(params) do

  end
end
