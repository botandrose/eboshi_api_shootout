defmodule ElixirPhoenix.RootControllerTest do
  use ElixirPhoenix.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert text_response(conn, 200) =~ "hello world"
  end
end
