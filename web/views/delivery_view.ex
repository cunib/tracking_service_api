defmodule TrackingServiceApi.DeliveryView do
  use TrackingServiceApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:start_date, :finish_date, :inserted_at, :updated_at]
  
  has_one :delivery_man,
    field: :delivery_man_id,
    type: "delivery_man"

end
