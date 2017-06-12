defmodule SharedShopper.ShoppinglistTest do
  use SharedShopper.ModelCase

  alias SharedShopper.Shoppinglist

  @valid_attrs %{completed: true, description: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Shoppinglist.changeset(%Shoppinglist{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Shoppinglist.changeset(%Shoppinglist{}, @invalid_attrs)
    refute changeset.valid?
  end
end
