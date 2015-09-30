defmodule ElixirPhoenix.ClientControllerTest do
  use ElixirPhoenix.ConnCase

  alias ElixirPhoenix.Client
  @valid_attrs %{address: "some content", city: "some content", contact: "some content", country: "some content", created_at: "2010-04-17 14:00:00", email: "some content", name: "some content", phone: "some content", state: "some content", updated_at: "2010-04-17 14:00:00", zip: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, client_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    client = Repo.insert! %Client{}
    conn = get conn, client_path(conn, :show, client)
    assert json_response(conn, 200)["data"] == %{"id" => client.id,
      "name" => client.name,
      "address" => client.address,
      "city" => client.city,
      "state" => client.state,
      "zip" => client.zip,
      "country" => client.country,
      "email" => client.email,
      "contact" => client.contact,
      "phone" => client.phone,
      "created_at" => client.created_at,
      "updated_at" => client.updated_at}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, client_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, client_path(conn, :create), client: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Client, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, client_path(conn, :create), client: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    client = Repo.insert! %Client{}
    conn = put conn, client_path(conn, :update, client), client: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Client, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    client = Repo.insert! %Client{}
    conn = put conn, client_path(conn, :update, client), client: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    client = Repo.insert! %Client{}
    conn = delete conn, client_path(conn, :delete, client)
    assert response(conn, 204)
    refute Repo.get(Client, client.id)
  end
end
