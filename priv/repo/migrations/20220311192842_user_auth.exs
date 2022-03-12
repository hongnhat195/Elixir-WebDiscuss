defmodule Discuss.Repo.Migrations.UserAuth do
  use Ecto.Migration

  def change do
    create table(:users) do
            add(:email, :string)
            add(:provider, :string)
            add(:token, :string)
            add(:password, :string)
            # timestamps()
          end
  end
end
