defmodule TrackingServiceApi.Repo.Migrations.CreateBusiness do
  use Ecto.Migration

  def change do
    create table(:businesses) do
      add :name, :string
      add :address, :string

      timestamps()
    end

  end
end
