defmodule TrackingServiceApi.OrderView do
  use TrackingServiceApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:start_date, :finish_date, :address, :inserted_at, :updated_at]
  
  has_one :business,
    field: :business_id,
    type: "business"

  has_one :delivery,
    field: :delivery_id,
    type: "delivery"

end
