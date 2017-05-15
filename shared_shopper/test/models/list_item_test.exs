defmodule SharedShopper.ListItemTest do
  use SharedShopper.ModelCase

  alias SharedShopper.ListItem

  @valid_attrs %{completed: true, description: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ListItem.changeset(%ListItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ListItem.changeset(%ListItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
