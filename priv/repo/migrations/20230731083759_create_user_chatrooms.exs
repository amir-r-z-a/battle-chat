defmodule Verify.Repo.Migrations.CreateUserChatrooms do
  use Ecto.Migration

  def change do
    create table(:user_chatrooms) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :chatroom_id, references(:chatrooms, on_delete: :delete_all)

      timestamps()
    end

    create index(:user_chatrooms, [:user_id])
    create index(:user_chatrooms, [:chatroom_id])
  end
  # defmodule Verify.Repo.Migrations.CreateUserChatrooms do
  #   use Ecto.Migration

  #   def change do
  #     create table(:user_chatrooms) do
  #       add :user_id, references(:users, on_delete: :delete_all)
  #       add :chatroom_id, references(:chatrooms, on_delete: :delete_all)

  #       timestamps()
  #     end

  #     create index(:user_chatrooms, [:user_id])
  #     create index(:user_chatrooms, [:chatroom_id])
  #   end
  # end

end
