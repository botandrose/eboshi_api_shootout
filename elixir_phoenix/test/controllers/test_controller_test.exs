defmodule ElixirPhoenix.RootControllerTest do
  use ElixirPhoenix.ConnCase

  test "GET /api/test" do
    conn = get conn(), "/api/test"
    assert text_response(conn, 200) =~ "Hello world"
  end
end
