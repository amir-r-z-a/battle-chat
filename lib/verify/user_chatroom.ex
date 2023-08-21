defmodule Verify.UserChatroom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_chatrooms" do

    belongs_to :user, Verify.Users.User
    belongs_to :chatroom, Verify.Chatroom

    timestamps()
  end

  @doc false
  def changeset(user_chatroom, attrs) do
    user_chatroom
    |> cast(attrs, [])
    |> validate_required([])
  end
end
