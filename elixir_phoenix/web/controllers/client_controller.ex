defmodule ElixirPhoenix.ClientController do
  use ElixirPhoenix.Web, :controller

  alias EboshiApiShootoutElixirPhoenix.Client
  alias EboshiApiShootoutElixirPhoenix.Repo

  plug :scrub_params, "client" when action in [:create, :update]

  def index(conn, _params) do
    clients = Repo.all(Client)
    render(conn, "index.json", clients: clients)
  end

  def create(conn, %{"client" => client_params}) do
    changeset = Client.changeset(%Client{}, client_params)

    case Repo.insert(changeset) do
      {:ok, client} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", client_path(conn, :show, client))
        |> render("show.json", client: client)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(EboshiApiShootoutElixirPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    client = Repo.get!(Client, id)
    render conn, "show.json", client: client
  end

  def update(conn, %{"id" => id, "client" => client_params}) do
    client = Repo.get!(Client, id)
    changeset = Client.changeset(client, client_params)

    case Repo.update(changeset) do
      {:ok, client} ->
        render(conn, "show.json", client: client)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(EboshiApiShootoutElixirPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    client = Repo.get!(Client, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(client)

    send_resp(conn, :no_content, "")
  end
end
