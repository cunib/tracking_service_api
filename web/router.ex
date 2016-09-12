defmodule TrackingServiceApi.Router do
  use TrackingServiceApi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json", "json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  scope "/", TrackingServiceApi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", TrackingServiceApi do
    pipe_through :api
    resources "/businesses", BusinessController, except: [:new, :edit] do
      resources "/delivery_men", DeliveryManController, only: [:index]
      resources "/orders", OrderController, only: [:index]
    end

    resources "/orders", OrderController, except: [:new, :edit]
    resources "/delivery_men", DeliveryManController, except: [:new, :edit]
  end
end
