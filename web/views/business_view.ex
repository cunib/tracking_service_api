defmodule TrackingServiceApi.BusinessView do
  use TrackingServiceApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :address, :inserted_at, :updated_at]
  

end
