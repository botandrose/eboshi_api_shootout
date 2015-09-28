defmodule ElixirPhoenix.Router do
  use ElixirPhoenix.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ElixirPhoenix do
    pipe_through :api

    get "/test", TestController, :hello_world
  end
end
