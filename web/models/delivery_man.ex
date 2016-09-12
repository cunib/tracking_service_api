defmodule TrackingServiceApi.DeliveryMan do
  use TrackingServiceApi.Web, :model

  schema "delivery_men" do
    field :username, :string
    belongs_to :business, TrackingServiceApi.Business

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username])
    |> validate_required([:username])
  end
end
