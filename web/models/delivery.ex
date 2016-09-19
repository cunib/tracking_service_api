defmodule TrackingServiceApi.Delivery do
  use TrackingServiceApi.Web, :model

  schema "deliveries" do
    field :start_date, Ecto.DateTime
    field :finish_date, Ecto.DateTime
    belongs_to :delivery_man, TrackingServiceApi.DeliveryMan
    has_many :orders, TrackingServiceApi.Order

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:start_date, :finish_date])
    |> validate_required([:start_date, :finish_date])
  end
end
