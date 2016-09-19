defmodule TrackingServiceApi.Order do
  use TrackingServiceApi.Web, :model

  schema "orders" do
    field :start_date, Ecto.DateTime
    field :finish_date, Ecto.DateTime
    field :address, :string
    belongs_to :business, TrackingServiceApi.Business
    has_many :deliveries, TrackingServiceApi.Delivery

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:start_date, :finish_date, :address])
    |> validate_required([:start_date, :finish_date, :address])
  end
end
