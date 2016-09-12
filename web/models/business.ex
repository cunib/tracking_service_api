defmodule TrackingServiceApi.Business do
  use TrackingServiceApi.Web, :model

  schema "businesses" do
    field :name, :string
    field :address, :string
    has_many :delivery_men, TrackingServiceApi.DeliveryMan

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :address])
    |> validate_required([:name, :address])
  end
end
