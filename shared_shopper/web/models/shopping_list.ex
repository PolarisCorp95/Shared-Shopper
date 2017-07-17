defmodule SharedShopper.Shoppinglist do
  use SharedShopper.Web, :model

  schema "shoppinglist" do
    field :title, :string
    field :description, :string
    field :completed, :boolean, default: false
    field :people, :map
    field :creator, :string
    belongs_to :user, SharedShopper.User
    has_many :todos, SharedShopper.Todo
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(filter(params), [:title, :description, :completed, :people, :creator])
    |> validate_required([:title, :description, :completed])
    |> unique_constraint(:people)
  end

  defp filter(%{"people" => people} = params) when is_binary(people) do
    map = List.delete_at(String.split(people,","),-1)
      |> Enum.map(&String.split(&1, ";"))
      |> Map.new(fn [k, v] -> {k, v} end)
    params = Map.put params, "people", map
  end

  defp filter(params), do: params

end
