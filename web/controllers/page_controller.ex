defmodule TrackingServiceApi.PageController do
  use TrackingServiceApi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
