defmodule ElixirPhoenix.ClientView do
  use ElixirPhoenix.Web, :view

  def render("index.json", %{clients: clients}) do
    %{data: render_many(clients, ElixirPhoenix.ClientView, "client.json")}
  end

  def render("show.json", %{client: client}) do
    %{data: render_one(client, ElixirPhoenix.ClientView, "client.json")}
  end

  def render("client.json", %{client: client}) do
    %{id: client.id,
      name: client.name,
      address: client.address,
      city: client.city,
      state: client.state,
      zip: client.zip,
      country: client.country,
      email: client.email,
      contact: client.contact,
      phone: client.phone,
      created_at: client.created_at,
      updated_at: client.updated_at}
  end
end
