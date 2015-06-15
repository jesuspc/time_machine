defmodule TimeMachine.Api.V1.ClocksController do
  use Phoenix.Controller

  plug :action

  def show(conn, params) do
    render conn, clock: clock(params)
  end

  def create(conn, params) do
    conn |> put_status(200)
  end

  defp clock(params) do
    params |> iden_from_params |> get_clock
  end

  defp get_clock(:default) do
    TimeMachine.Clock.get :default
  end
  defp get_clock(iden) do
    case TimeMachine.Registry.lookup TimeMachine.Registry, iden do
      :error     -> :error#TODO
      {:ok, pid} -> TimeMachine.Clock.get pid
    end
  end

  defp iden_from_params(params) do
    params[:iden] || :default
  end
end
