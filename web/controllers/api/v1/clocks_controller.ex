defmodule TimeMachine.Api.V1.ClocksController do
  use Phoenix.Controller
  use Timex
  plug :action

  def show(conn, params) do
    render conn, clock: clock(params)
  end

  def create(conn, params) do
    params |> iden_from_params |> put_clock(params["time"], String.to_integer(params["count"]))
    conn |> put_status(200) |> render
  end

  defp clock(params) do
    params |> iden_from_params |> get_clock
  end

  defp get_clock(iden, recurring \\ false) do
    case TimeMachine.Registry.lookup TimeMachine.Registry, iden do
      :error     -> 
        if recurring, do: put_clock(iden)
        get_clock(iden, true)
      {:ok, pid} ->
        {:ok, clock} = TimeMachine.Clock.get pid
        clock
    end
  end

  defp put_clock(iden) do
    TimeMachine.Registry.create TimeMachine.Registry, iden
  end
  defp put_clock(iden, time, count) do
    args = build_clock(time, count)
    TimeMachine.Registry.create TimeMachine.Registry, iden, args
  end

  defp iden_from_params(params) do
    params["iden"] || :default
  end

  defp build_clock(time, count) do
    Enum.map 1..count, fn(_) ->
      {:ok, date_time} = time |> DateFormat.parse("{ISOz}")
      date_time |> Date.convert(:secs)
    end
  end
end
