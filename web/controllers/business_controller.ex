defmodule TrackingServiceApi.BusinessController do
  use TrackingServiceApi.Web, :controller

  alias TrackingServiceApi.Business
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    businesses = Repo.all(Business)
    render(conn, "index.json-api", data: businesses)
  end

  def create(conn, %{"data" => data = %{"type" => "business", "attributes" => _business_params}}) do
    changeset = Business.changeset(%Business{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, business} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", business_path(conn, :show, business))
        |> render("show.json-api", data: business)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    business = Repo.get!(Business, id)
    render(conn, "show.json-api", data: business)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "business", "attributes" => _business_params}}) do
    business = Repo.get!(Business, id)
    changeset = Business.changeset(business, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, business} ->
        render(conn, "show.json-api", data: business)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    business = Repo.get!(Business, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(business)

    send_resp(conn, :no_content, "")
  end

end
