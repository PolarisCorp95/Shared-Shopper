defmodule SharedShopper.ShoppingListTest do
  use SharedShopper.ModelCase

  alias SharedShopper.ShoppingList

  @valid_attrs %{completed: true, description: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ShoppingList.changeset(%ShoppingList{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ShoppingList.changeset(%ShoppingList{}, @invalid_attrs)
    refute changeset.valid?
  end
end
