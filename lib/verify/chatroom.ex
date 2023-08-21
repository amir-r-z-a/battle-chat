defmodule Verify.Chatroom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chatrooms" do
    field :name, :string

    many_to_many :users, Verify.Users.User, join_through: Verify.UserChatroom
    has_many :messages, Verify.Message
    timestamps()

  end

  @doc false
  def changeset(chatroom, attrs) do
    chatroom
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
