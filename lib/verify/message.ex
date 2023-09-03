defmodule Verify.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do

    field :content, :string

    belongs_to :user, Verify.Users.User
    belongs_to :chatroom, Verify.Chatroom
    field :is_private, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content])
    |> validate_required([:content, :user, :chatroom, :user_id, :chatroom_id])
  end
end
