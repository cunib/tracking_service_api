defmodule TrackingServiceApi.DeliveryControllerTest do
  use TrackingServiceApi.ConnCase

  alias TrackingServiceApi.Delivery
  alias TrackingServiceApi.Repo

  @valid_attrs %{finish_date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, start_date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
  
  defp relationships do 
    delivery_man = Repo.insert!(%TrackingServiceApi.DeliveryMan{})

    %{
      "delivery_man" => %{
        "data" => %{
          "type" => "delivery_man",
          "id" => delivery_man.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, delivery_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    delivery = Repo.insert! %Delivery{}
    conn = get conn, delivery_path(conn, :show, delivery)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{delivery.id}"
    assert data["type"] == "delivery"
    assert data["attributes"]["start_date"] == delivery.start_date
    assert data["attributes"]["finish_date"] == delivery.finish_date
    assert data["attributes"]["delivery_man_id"] == delivery.delivery_man_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, delivery_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, delivery_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "delivery",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Delivery, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, delivery_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "delivery",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    delivery = Repo.insert! %Delivery{}
    conn = put conn, delivery_path(conn, :update, delivery), %{
      "meta" => %{},
      "data" => %{
        "type" => "delivery",
        "id" => delivery.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Delivery, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    delivery = Repo.insert! %Delivery{}
    conn = put conn, delivery_path(conn, :update, delivery), %{
      "meta" => %{},
      "data" => %{
        "type" => "delivery",
        "id" => delivery.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    delivery = Repo.insert! %Delivery{}
    conn = delete conn, delivery_path(conn, :delete, delivery)
    assert response(conn, 204)
    refute Repo.get(Delivery, delivery.id)
  end

end
