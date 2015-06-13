defmodule TimeMachine.Router do
  use TimeMachine.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TimeMachine do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", TimeMachine.Api, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      get "/clock", ClocksController, :show
      post "/clocks", ClocksController, :create
      get "/clocks/:id", ClocksController, :show
      post "/clocks/:id", ClocksController, :create
    end
  end
end
