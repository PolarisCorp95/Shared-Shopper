defmodule SharedShopper.RoleChecker do
  alias SharedShopper.Repo
  alias SharedShopper.Role

  def is_admin?(user) do
    (role = Repo.get(Role, user.role_id)) && role.admin
  end
end
