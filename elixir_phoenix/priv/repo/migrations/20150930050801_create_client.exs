defmodule EboshiApiShootoutElixirPhoenix.Repo.Migrations.CreateClient do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :name, :string
      add :address, :string
      add :city, :string
      add :state, :string
      add :zip, :string
      add :country, :string
      add :email, :string
      add :contact, :string
      add :phone, :string
      add :created_at, :datetime
      add :updated_at, :datetime

      timestamps
    end

  end
end
