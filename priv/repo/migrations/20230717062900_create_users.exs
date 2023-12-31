defmodule Verify.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :number, :string, null: false
      add :password_hash, :string
      add :random , :integer
      timestamps()
    end

    create unique_index(:users, [:number])
  end
end
