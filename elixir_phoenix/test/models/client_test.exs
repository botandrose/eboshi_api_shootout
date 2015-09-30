defmodule ElixirPhoenix.ClientTest do
  use ElixirPhoenix.ModelCase

  alias ElixirPhoenix.Client

  @valid_attrs %{address: "some content", city: "some content", contact: "some content", country: "some content", created_at: "2010-04-17 14:00:00", email: "some content", name: "some content", phone: "some content", state: "some content", updated_at: "2010-04-17 14:00:00", zip: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Client.changeset(%Client{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Client.changeset(%Client{}, @invalid_attrs)
    refute changeset.valid?
  end
end
