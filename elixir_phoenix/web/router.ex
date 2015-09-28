defmodule ElixirPhoenix.Router do
  use ElixirPhoenix.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixirPhoenix do
    pipe_through :api

    get "/", RootController, :hello_world
  end
end
