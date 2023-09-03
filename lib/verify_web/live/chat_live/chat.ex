defmodule VerifyWeb.Live.ChatLive.Chat do
  alias Verify.{Message, Users.User, Chatroom, Repo, Chert}
  import Ecto
  use Phoenix.LiveView

  # use VerifyWeb, :live_component

  def mount(params, session, socket) do
    IO.inspect(params, label: "params")
    chatroom_id = Map.get(params, "id")
    IO.inspect(chatroom_id, label: "chatroom_id")
    chats = Verify.Chert.get_messages(chatroom_id)
    IO.inspect(session, label: "session")
    userID = Map.get(session, "user")
    random_num = Repo.get(User, userID).random
    if connected?(socket), do: Chert.subscribe(chatroom_id)

    {:ok,
     socket
     |> assign(:user_id, userID)
     |> assign(:random_num, random_num)
     |> assign(:chatroom_id, chatroom_id)
     |> assign(:form, to_form(Message.changeset(%Message{}, %{})))
     |> assign(:chats, chats)}
  end

  def render(assigns) do
    ~H"""
    <%!-- <%=IO.inspect(@chats, label: "assigns")%> --%>
    <%= for m <- @chats do %>
      <%= live_component(VerifyWeb.Live.ChatLive.ChatComponent,
        content: m.content,
        id: m.id,
        user_number: m.user.number,
        chat_user_id: m.user.id,
        user_id: @user_id,
        is_private: m.is_private
      ) %>
    <% end %>

    <%= live_component(VerifyWeb.Live.ChatLive.FormComponent, id: @user_id, form: @form) %>

    <%= if @random_num do %>
      <div>
        <h1>your random is <%= @random_num %></h1>
      </div>
    <% end %>
    """
  end

  def handle_event("save", params, socket) do
    # IO.inspect(socket.assigns, label: "unsigned_params")
    content =
      params
      |> Map.get("message")
      |> Map.get("content")

    splited = String.split(content, " ")

    # Repo.insert!(%Message{content: content, user: Repo.get!(User, socket.assigns.user_id), chatroom: Repo.get!(Chatroom, socket.assigns.chatroom_id) })

    if content == "/start" do
      message = %Message{
        content: content,
        user: Repo.get!(User, socket.assigns.user_id),
        chatroom: Repo.get!(Chatroom, socket.assigns.chatroom_id),
        is_private: true
      }

      Chert.save_message(message)

      start(socket)
    else
      message = %Message{
        content: content,
        user: Repo.get!(User, socket.assigns.user_id),
        chatroom: Repo.get!(Chatroom, socket.assigns.chatroom_id)
      }

      Chert.save_message(message)
    end

    if Enum.at(splited, 0) == "/fight" and length(splited) == 2 do
      invited_user_number = Enum.at(splited, 1)

      case Repo.get_by(User, number: invited_user_number) do
        nil ->
          user_not_found_message = %Message{
            content: "user not found",
            user: Repo.get!(User, socket.assigns.user_id),
            chatroom: Repo.get!(Chatroom, socket.assigns.chatroom_id),
            is_private: true
          }

          Repo.insert!(user_not_found_message)

        invited_user_random ->
          IO.inspect(invited_user_random.random, label: "---------------------------------------")

          case invited_user_random.random do
            nil ->
              no_random_message_invited = %Message{
                content: "invited user has no random number",
                user: Repo.get!(User, socket.assigns.user_id),
                chatroom: Repo.get!(Chatroom, socket.assigns.chatroom_id),
                is_private: true
              }

              Repo.insert!(no_random_message_invited)

            _ ->
              case socket.assigns.random_num do
                nil ->
                  no_random_message_user = %Message{
                    content: "you dont random",
                    user: Repo.get!(User, socket.assigns.user_id),
                    chatroom: Repo.get!(Chatroom, socket.assigns.chatroom_id),
                    is_private: true
                  }

                  Repo.insert!(no_random_message_user)

                _ ->
                  if invited_user_random.random > socket.assigns.random_num do
                    win_message = %Message{
                      content: "you loose",
                      user: Repo.get!(User, socket.assigns.user_id),
                      chatroom: Repo.get!(Chatroom, socket.assigns.chatroom_id),
                      is_private: true
                    }

                    Repo.insert!(win_message)
                  else
                    loose_message = %Message{
                      content: "you win",
                      user: Repo.get!(User, socket.assigns.user_id),
                      chatroom: Repo.get!(Chatroom, socket.assigns.chatroom_id),
                      is_private: true
                    }

                    Repo.insert!(loose_message)
                  end
              end
          end
      end
    end

    {:noreply, socket}
  end

  # @impl true
  def handle_info({:new_message, _message}, socket) do
    # IO.inspect(socket.assigns, label: "handle_info")
    {:noreply,
     socket
     |> assign(:chats, Chert.get_messages(socket.assigns.chatroom_id))
     |> assign(:random_num, Chert.get_user_randomnum(socket.assigns.user_id))}
  end

  def start(socket) do
    random_number = :rand.uniform(100)
    user = Repo.get(User, socket.assigns.user_id)
    changeSet = Ecto.Changeset.change(user, %{random: random_number})
    Repo.update!(changeSet)
    socket
  end
end
