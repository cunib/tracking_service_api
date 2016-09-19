defmodule TrackingServiceApi.DeliveryController do
  use TrackingServiceApi.Web, :controller

  alias TrackingServiceApi.Delivery
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    deliveries = Repo.all(Delivery)
    render(conn, "index.json-api", data: deliveries)
  end

  def create(conn, %{"data" => data = %{"type" => "delivery", "attributes" => _delivery_params}}) do
    changeset = Delivery.changeset(%Delivery{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, delivery} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", delivery_path(conn, :show, delivery))
        |> render("show.json-api", data: delivery)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    delivery = Repo.get!(Delivery, id)
    render(conn, "show.json-api", data: delivery)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "delivery", "attributes" => _delivery_params}}) do
    delivery = Repo.get!(Delivery, id)
    changeset = Delivery.changeset(delivery, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, delivery} ->
        render(conn, "show.json-api", data: delivery)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    delivery = Repo.get!(Delivery, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(delivery)

    send_resp(conn, :no_content, "")
  end

end
