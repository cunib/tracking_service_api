defmodule TrackingServiceApi.BusinessControllerTest do
  use TrackingServiceApi.ConnCase

  alias TrackingServiceApi.Business
  alias TrackingServiceApi.Repo

  @valid_attrs %{address: "some content", name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
  
  defp relationships do
    %{}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, business_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    business = Repo.insert! %Business{}
    conn = get conn, business_path(conn, :show, business)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{business.id}"
    assert data["type"] == "business"
    assert data["attributes"]["name"] == business.name
    assert data["attributes"]["address"] == business.address
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, business_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, business_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "business",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Business, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, business_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "business",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    business = Repo.insert! %Business{}
    conn = put conn, business_path(conn, :update, business), %{
      "meta" => %{},
      "data" => %{
        "type" => "business",
        "id" => business.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Business, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    business = Repo.insert! %Business{}
    conn = put conn, business_path(conn, :update, business), %{
      "meta" => %{},
      "data" => %{
        "type" => "business",
        "id" => business.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    business = Repo.insert! %Business{}
    conn = delete conn, business_path(conn, :delete, business)
    assert response(conn, 204)
    refute Repo.get(Business, business.id)
  end

end
