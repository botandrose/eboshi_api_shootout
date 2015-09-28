defmodule ElixirPhoenix.RootController do
  use ElixirPhoenix.Web, :controller

  def hello_world(conn, _params) do
    conn |> text "hello world"
  end
end
