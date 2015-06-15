defmodule TimeMachine.ClocksControllerTest do
  use TimeMachine.ConnCase
  use Timex

  test "GET /api/v1/clock" do
    conn = get conn(), "/api/v1/clock"

    assert conn.state == :sent
    assert conn.status == 200
    body = Poison.decode!(conn.resp_body)
    assert body["clock"] == "SYS (fakeable)"
    assert is_integer(body["id"]) == true
    {:ok, time} = DateFormat.parse body["time"], "{ISOz}"
    assert is_map(time) == true
  end

  test "POST /api/v1/clock with valid params" do
    time = "2015-06-15T18:42:02Z"
    conn = post conn(), "/api/v1/clock", time: time, count: 1

    assert conn.status == 200
    assert conn.resp_body == nil
    assert TimeMachine.Clock.get(:default).time == time
    assert TimeMachine.Clock.get(:default).time != time
  end
end
