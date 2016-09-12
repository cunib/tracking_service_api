defmodule TrackingServiceApi.Repo.Migrations.CreateOrder do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :start_date, :datetime
      add :finish_date, :datetime
      add :address, :string
      add :business_id, references(:businesses, on_delete: :nothing)

      timestamps()
    end
    create index(:orders, [:business_id])

  end
end
