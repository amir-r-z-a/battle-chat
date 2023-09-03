defmodule Verify.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :chatroom_id, references(:chatrooms, on_delete: :delete_all)
      add :is_private, :boolean, default: false
      timestamps()
    end

    create index(:messages, [:user_id])
  end
end
