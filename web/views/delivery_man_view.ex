defmodule TrackingServiceApi.DeliveryManView do
  use TrackingServiceApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:username, :inserted_at, :updated_at]
  
  has_one :business,
    field: :business_id,
    type: "business"

end
