defmodule TimeMachine.ClockTest do
  use TimeMachine.ConnCase

  test "start_link starts a link with the default clock when no clock given" do
    {:ok, pid} = TimeMachine.Clock.start_link(time: :time)
    assert TimeMachine.Clock.get(pid).time === :time
    assert TimeMachine.Clock.get(pid).clock === "SYS (fakeable)"
  end

  test "start_link starts a link with the given clock when clock given" do
    {:ok, pid} = TimeMachine.Clock.start_link(time: :time, clock: :clock)
    assert TimeMachine.Clock.get(pid).time === :time
    assert TimeMachine.Clock.get(pid).clock === :clock
  end

  test "get returns the clock without modifications if its clock is not a list" do
    {:ok, pid} = TimeMachine.Clock.start_link(time: :time_1, clock: :clock_1)
    TimeMachine.Clock.get(pid)
    clock_1 = TimeMachine.Clock.get(pid)
    clock_2 = TimeMachine.Clock.get(pid)
    assert clock_1 === clock_2
  end

  test "get returns the clock substracting one clock element if its clock is a list" do
    {:ok, pid} = TimeMachine.Clock.start_link(time: :time_1, clock: [1,2,3])
    TimeMachine.Clock.get(pid)
    clock_1 = TimeMachine.Clock.get(pid)
    clock_2 = TimeMachine.Clock.get(pid)
    assert clock_1 !== clock_2
    assert tl(clock_1.clock) === clock_2.clock
  end

  #test "get kills the agent if the clock is empty after being popped if its clock is a list" do
    #{:ok, pid} = TimeMachine.Clock.start_link(time: :time_1, clock: [1,2,3])
    #TimeMachine.Clock.get(clock)
    #clock_1 = TimeMachine.Clock.get(pid)
    #clock_2 = TimeMachine.Clock.get(pid)
    #assert clock_1 !== clock_2
    #assert clock_1.clock === clock_2.clock
  #end

  #test "get returns an error if trying to fetch a non spawned Agent" do
    #{:ok, pid} = TimeMachine.Clock.start_link(time: :time_1, clock: [1,2,3])
    #TimeMachine.Clock.get(clock)
    #clock_1 = TimeMachine.Clock.get(pid)
    #clock_2 = TimeMachine.Clock.get(pid)
    #assert clock_1 !== clock_2
    #assert clock_1.clock === clock_2.clock
  #end

  test "put updates the given clock with the given attributes" do
    {:ok, pid} = TimeMachine.Clock.start_link(time: :time_1, clock: :clock_1)
    TimeMachine.Clock.put(pid, time: :time_2, clock: :clock_2)
    clock = TimeMachine.Clock.get(pid)
    assert clock.time === :time_2
    assert clock.clock === :clock_2
  end
end
