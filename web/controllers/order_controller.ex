defmodule TrackingServiceApi.OrderController do
  use TrackingServiceApi.Web, :controller

  alias TrackingServiceApi.Order
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    orders = Repo.all(Order)
    render(conn, "index.json-api", data: orders)
  end

  def create(conn, %{"data" => data = %{"type" => "order", "attributes" => _order_params}}) do
    changeset = Order.changeset(%Order{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, order} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", order_path(conn, :show, order))
        |> render("show.json-api", data: order)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    order = Repo.get!(Order, id)
    render(conn, "show.json-api", data: order)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "order", "attributes" => _order_params}}) do
    order = Repo.get!(Order, id)
    changeset = Order.changeset(order, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, order} ->
        render(conn, "show.json-api", data: order)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    order = Repo.get!(Order, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(order)

    send_resp(conn, :no_content, "")
  end

end
