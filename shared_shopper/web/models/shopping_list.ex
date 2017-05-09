defmodule SharedShopper.ShoppingList do
  use SharedShopper.Web, :model

  schema "shoppinglists" do
    field :title, :string
    field :description, :string
    field :completed, :boolean, default: false
    field :list_items, {:array, :string}
    belongs_to :user, SharedShopper.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :completed, :list_items])
    |> validate_required([:title, :description, :completed, :list_items])
  end
end
