defmodule TrackingServiceApi.DeliveryManController do
  use TrackingServiceApi.Web, :controller

  alias TrackingServiceApi.DeliveryMan
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    delivery_men = Repo.all(DeliveryMan)
    render(conn, "index.json-api", data: delivery_men)
  end

  def create(conn, %{"data" => data = %{"type" => "delivery_man", "attributes" => _delivery_man_params}}) do
    changeset = DeliveryMan.changeset(%DeliveryMan{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, delivery_man} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", delivery_man_path(conn, :show, delivery_man))
        |> render("show.json-api", data: delivery_man)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    delivery_man = Repo.get!(DeliveryMan, id)
    render(conn, "show.json-api", data: delivery_man)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "delivery_man", "attributes" => _delivery_man_params}}) do
    delivery_man = Repo.get!(DeliveryMan, id)
    changeset = DeliveryMan.changeset(delivery_man, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, delivery_man} ->
        render(conn, "show.json-api", data: delivery_man)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    delivery_man = Repo.get!(DeliveryMan, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(delivery_man)

    send_resp(conn, :no_content, "")
  end

end
