defmodule TrackingServiceApi.DeliveryManControllerTest do
  use TrackingServiceApi.ConnCase

  alias TrackingServiceApi.DeliveryMan
  alias TrackingServiceApi.Repo

  @valid_attrs %{username: "some content"}
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
    conn = get conn, delivery_man_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    delivery_man = Repo.insert! %DeliveryMan{}
    conn = get conn, delivery_man_path(conn, :show, delivery_man)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{delivery_man.id}"
    assert data["type"] == "delivery_man"
    assert data["attributes"]["username"] == delivery_man.username
    assert data["attributes"]["business_id"] == delivery_man.business_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, delivery_man_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, delivery_man_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "delivery_man",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(DeliveryMan, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, delivery_man_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "delivery_man",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    delivery_man = Repo.insert! %DeliveryMan{}
    conn = put conn, delivery_man_path(conn, :update, delivery_man), %{
      "meta" => %{},
      "data" => %{
        "type" => "delivery_man",
        "id" => delivery_man.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(DeliveryMan, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    delivery_man = Repo.insert! %DeliveryMan{}
    conn = put conn, delivery_man_path(conn, :update, delivery_man), %{
      "meta" => %{},
      "data" => %{
        "type" => "delivery_man",
        "id" => delivery_man.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    delivery_man = Repo.insert! %DeliveryMan{}
    conn = delete conn, delivery_man_path(conn, :delete, delivery_man)
    assert response(conn, 204)
    refute Repo.get(DeliveryMan, delivery_man.id)
  end

end
