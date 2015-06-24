defmodule TimeMachine.ClockTest do
  use TimeMachine.ConnCase

  test "start_link starts a link with the default clock when no clock given" do
    {:ok, pid} = TimeMachine.Clock.start_link([])
    {:ok, clock} = TimeMachine.Clock.get(pid)
    assert clock.clock === []
  end

  test "start_link starts a link with the given clock when clock given" do
    {:ok, pid} = TimeMachine.Clock.start_link([:clock])
    {:ok, clock} = TimeMachine.Clock.get(pid)
    assert clock.clock === [:clock]
  end

  test "get returns the clock substracting one clock element if its clock is a list" do
    {:ok, pid} = TimeMachine.Clock.start_link([1,2,3])
    {:ok, clock_1} = TimeMachine.Clock.get(pid)
    {:ok, clock_2} = TimeMachine.Clock.get(pid)
    assert clock_1.clock !== clock_2.clock
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
    {:ok, pid} = TimeMachine.Clock.start_link(clock: :clock_1)
    TimeMachine.Clock.put(pid, :clock_2)
    {:ok, clock}=TimeMachine.Clock.get(pid)
    assert clock.clock === :clock_2
  end
end
