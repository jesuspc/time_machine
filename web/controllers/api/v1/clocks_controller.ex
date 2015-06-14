defmodule TimeMachine.Api.V1.ClocksController do
  use Phoenix.Controller

  plug :action

  def show(conn, params) do
    render conn, clock: clock(params)
  end

  def create(conn, params) do

  end

  defp clock(params) do
    params |> iden_from_params |> get_clock
  end

  defp get_clock(iden) do
    {:ok, pid} = TimeMachine.Registry.lookup TimeMachine.Registry, iden
    TimeMachine.Clock.get pid
  end

  defp iden_from_params(params) do
    params[:iden] || :default
  end
end
