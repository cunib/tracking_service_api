defmodule TrackingServiceApi.OrderControllerTest do
  use TrackingServiceApi.ConnCase

  alias TrackingServiceApi.Order
  alias TrackingServiceApi.Repo

  @valid_attrs %{address: "some content", finish_date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, start_date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
  
  defp relationships do 
    business = Repo.insert!(%TrackingServiceApi.Business{})

    %{
      "business" => %{
        "data" => %{
          "type" => "business",
          "id" => business.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, order_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    order = Repo.insert! %Order{}
    conn = get conn, order_path(conn, :show, order)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{order.id}"
    assert data["type"] == "order"
    assert data["attributes"]["start_date"] == order.start_date
    assert data["attributes"]["finish_date"] == order.finish_date
    assert data["attributes"]["address"] == order.address
    assert data["attributes"]["business_id"] == order.business_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, order_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, order_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "order",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Order, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, order_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "order",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    order = Repo.insert! %Order{}
    conn = put conn, order_path(conn, :update, order), %{
      "meta" => %{},
      "data" => %{
        "type" => "order",
        "id" => order.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Order, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    order = Repo.insert! %Order{}
    conn = put conn, order_path(conn, :update, order), %{
      "meta" => %{},
      "data" => %{
        "type" => "order",
        "id" => order.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    order = Repo.insert! %Order{}
    conn = delete conn, order_path(conn, :delete, order)
    assert response(conn, 204)
    refute Repo.get(Order, order.id)
  end

end
