defmodule EboshiApiShootoutElixirPhoenix.Client do
  use Ecto.Model

  schema "clients" do
    field :name, :string
    field :address, :string
    field :city, :string
    field :state, :string
    field :zip, :string
    field :country, :string
    field :email, :string
    field :contact, :string
    field :phone, :string
    field :created_at, Ecto.DateTime
    field :updated_at, Ecto.DateTime
  end

  @required_fields ~w(name address city state zip country email contact phone created_at updated_at)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
