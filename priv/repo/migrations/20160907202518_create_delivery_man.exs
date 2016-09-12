defmodule TrackingServiceApi.Repo.Migrations.CreateDeliveryMan do
  use Ecto.Migration

  def change do
    create table(:delivery_men) do
      add :username, :string
      add :business_id, references(:businesses, on_delete: :nothing)

      timestamps()
    end
    create index(:delivery_men, [:business_id])

  end
end
