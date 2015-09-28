defmodule ElixirPhoenix.Router do
  use ElixirPhoenix.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixirPhoenix do
    pipe_through :api

    get "/", RootController, :hello_world
  end
end
