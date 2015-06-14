defmodule TimeMachine.ClocksControllerTest do
  use TimeMachine.ConnCase

  test "GET /api/v1/clock" do
    conn = get conn(), "/api/v1/clock"
    default_clock_as_json = Poison.encode!(%{a: 1})

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == default_clock_as_json
  end
end
