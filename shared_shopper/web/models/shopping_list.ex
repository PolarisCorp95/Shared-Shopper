defmodule SharedShopper.Shoppinglist do
  use SharedShopper.Web, :model

  schema "shoppinglist" do
    field :title, :string
    field :description, :string
    field :completed, :boolean, default: false
    field :people, :map
    belongs_to :user, SharedShopper.User
    has_many :todos, SharedShopper.Todo
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(filter(params), [:title, :description, :completed, :people])
    |> validate_required([:title, :description, :completed])
    |> unique_constraint(:people)
  end

  defp filter(%{"people" => people} = params) when is_binary(people) do
    IO.inspect people

    tempmap = Map.put_new(Map.new(), people, "abc")
    IO.inspect  tempmap

    params = Map.put params, "people", tempmap
  end

  defp filter(params), do: params

end
