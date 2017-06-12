defmodule SharedShopper.Todo do
  use SharedShopper.Web, :model

  schema "todos" do
    field :title, :string
    field :description, :string
    field :completed, :boolean, default: false
    field :completedby, :string
    belongs_to :shoppinglist, SharedShopper.Shoppinglist

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :completed])
    |> validate_required([:title, :description])
  end
end
