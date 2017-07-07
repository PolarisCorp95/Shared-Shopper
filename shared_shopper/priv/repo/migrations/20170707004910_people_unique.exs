defmodule SharedShopper.Repo.Migrations.PeopleUnique do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:username])

  end
end
