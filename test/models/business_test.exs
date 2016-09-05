defmodule TrackingServiceApi.BusinessTest do
  use TrackingServiceApi.ModelCase

  alias TrackingServiceApi.Business

  @valid_attrs %{address: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Business.changeset(%Business{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Business.changeset(%Business{}, @invalid_attrs)
    refute changeset.valid?
  end
end
