defmodule TimeMachine.RegistryControllerTest do
  use TimeMachine.ConnCase

  test "start_link" do
    #GenServer.cast(TimeMachine.Registry, :stop)
    #assert TimeMachine.Registry.lookup(TimeMachine.Registry, :default) == :error
    #TimeMachine.Registry.start_link
    #{:ok, pid} =  TimeMachine.Registry.lookup(TimeMachine.Registry, :default)
  end
end

