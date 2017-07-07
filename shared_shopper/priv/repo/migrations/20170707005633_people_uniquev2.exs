defmodule SharedShopper.Repo.Migrations.PeopleUniquev2 do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:username])

  end
end
