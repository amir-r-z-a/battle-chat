defmodule Verify.Chert do
  import Ecto.Query, warn: false
  alias Verify.{Users.User, Repo, Message}

  def get_user_reading(user_id) do
    IO.puts("hi")
    user = Repo.get(User, user_id)
    user.number
  end


  def get_chatrooms(user_id) do
    query = from u in User,
    where: u.id == ^user_id,
    preload: [:chatrooms]
    Repo.one(query).chatrooms
  end

  def get_messages(chatroom_id) do
    IO.inspect(chatroom_id, label: "chert")
    query = from m in Message,
    where: m.chatroom_id == ^chatroom_id,
    preload: [:user]
    Repo.all(query)
  end

  def save_message(message) do
    message
    |> Repo.insert()
    |> broadcast(:new_message)

  end

  def get_user_randomnum(user_id) do
    query = from u in User,
    where: u.id == ^user_id
    Repo.one(query).random
  end

  def subscribe(chatroom_id) do
    # IO.inspect(chatroom_id, label: "subscribe")
    Phoenix.PubSub.subscribe(Verify.PubSub, "chatroom:#{chatroom_id}")
  end

  defp broadcast({:ok, message}, event) do
    # IO.inspect(message, label: "broadcast")
    # IO.inspect(event, label: "broadcast")
    id = message.chatroom_id
    Phoenix.PubSub.broadcast(Verify.PubSub, "chatroom:#{id}", {event, message})
      {:ok, message}
  end



end
