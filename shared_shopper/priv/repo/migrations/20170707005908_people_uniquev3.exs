defmodule SharedShopper.Repo.Migrations.PeopleUniquev3 do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:email])

  end
end
