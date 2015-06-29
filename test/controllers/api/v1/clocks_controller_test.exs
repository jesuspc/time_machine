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

  # test "GET /api/v1/clock when the default clock is faked" do
  #   TimeMachine.Clock.put(:default, [1])
  #   conn = get conn(), "/api/v1/clock"

  #   assert conn.state == :sent
  #   assert conn.status == 200
  #   body = Poison.decode!(conn.resp_body)
  #   assert body["clock"] == "FAKE [1]"
  #   assert is_integer(body["id"]) == true
  #   {:ok, time} = DateFormat.parse body["time"], "{ISOz}"
  #   assert is_map(time) == true
  # end

  # test "POST /api/v1/clock with valid params" do
  #   time = "2015-06-15T18:42:02Z"
  #   conn = post conn(), "/api/v1/clock", time: time, count: "1"

  #   assert conn.status == 200
  #   assert conn.resp_body == "{}"
  #   {:ok, clock_1} = TimeMachine.Clock.get(:default)
  #   {:ok, clock_2} = TimeMachine.Clock.get(:default)
  #   assert clock_1.clock != clock_2.clock
  # end

  test "GET /api/v1/clocks/:iden when iden not previously defined" do
    conn = get conn(), "/api/v1/clocks/another_new_iden"

    assert conn.state == :sent
    assert conn.status == 200
    body = Poison.decode!(conn.resp_body)
    assert body["clock"] == "SYS (fakeable)"
    assert is_integer(body["id"]) == true
    {:ok, time} = DateFormat.parse body["time"], "{ISOz}"
    assert is_map(time) == true
  end

  test "GET /api/v1/clocks/:iden when iden previously defined" do
    TimeMachine.Registry.create TimeMachine.Registry, "new_iden", [1]
    conn = get conn(), "/api/v1/clocks/new_iden"

    assert conn.state == :sent
    assert conn.status == 200
    body = Poison.decode!(conn.resp_body)
    assert body["clock"] == "FAKE [1]"
    assert is_integer(body["id"]) == true
    {:ok, time} = DateFormat.parse body["time"], "{ISOz}"
    assert is_map(time) == true
  end

  test "POST /api/v1/clocks/:id with valid params" do
    time = "2015-06-15T18:42:02Z"
    conn = post conn(), "/api/v1/clocks/another_iden", time: time, count: "1"

    assert conn.status == 200
    assert conn.resp_body == "{}"
    {:ok, pid} = TimeMachine.Registry.lookup TimeMachine.Registry, "another_iden"
    {:ok, clock_1} = TimeMachine.Clock.get(pid)
    {:ok, clock_2} = TimeMachine.Clock.get(pid)
    assert clock_1.clock != clock_2.clock
  end
end
