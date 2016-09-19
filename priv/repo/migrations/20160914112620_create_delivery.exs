defmodule TrackingServiceApi.Repo.Migrations.CreateDelivery do
  use Ecto.Migration

  def change do
    create table(:deliveries) do
      add :start_date, :datetime
      add :finish_date, :datetime
      add :delivery_man_id, references(:delivery_men, on_delete: :nothing)

      timestamps()
    end
    create index(:deliveries, [:delivery_man_id])

  end
end
