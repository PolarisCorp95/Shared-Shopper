defmodule SharedShopper.Repo.Migrations.AddPeopleToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :people, {:array, :string}
    end
  end
end
