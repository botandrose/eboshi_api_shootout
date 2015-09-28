defmodule ElixirPhoenix.TestController do
  use ElixirPhoenix.Web, :controller

  def hello_world(conn, _params) do
    conn
    |> text "Hello world"
  end
end
