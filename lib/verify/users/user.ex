defmodule Verify.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema, user_id_field: :number

  schema "users" do
    field :number,           :string
    field :password_hash,    :string
    field :current_password, :string, virtual: true
    field :password,         :string, virtual: true
    field :confirm_password, :string, virtual: true

    many_to_many :chatrooms, Verify.Chatroom, join_through: Verify.UserChatroom

    has_many :messages, Verify.Message

    field :random, :integer

    timestamps()
  end
end
