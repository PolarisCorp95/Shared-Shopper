defmodule SharedShopper.User do
  use SharedShopper.Web, :model

  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  schema "users" do
    field :email, :string
    field :password_digest, :string
    field :name, :string
    field :username, :string
    has_many :shoppinglist, SharedShopper.ShoppingList
    belongs_to :role, SharedShopper.Role

    timestamps()

    # Virtual Fields
      field :password, :string, virtual: true
      field :password_confirmation, :string, virtual: true
    end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:username, :email, :password, :password_confirmation, :role_id])
      |> validate_required([:username, :email, :password, :password_confirmation, :role_id])
      |> hash_password
    end

    defp hash_password(changeset) do
      if password = get_change(changeset, :password) do
        changeset
        |> put_change(:password_digest, hashpwsalt(password))
      else
        changeset
      end
    end
end
