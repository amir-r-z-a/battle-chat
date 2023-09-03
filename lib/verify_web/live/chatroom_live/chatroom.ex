defmodule VerifyWeb.Live.ChatroomLive.Chatroom do

  alias Verify.{Users.User,Chatroom, Repo, UserChatroom}
  use Phoenix.LiveView

  import Ecto.Query

  def mount(_params, session ,socket) do
    # IO.inspect(get_connect_info(socket))
    chatrooms = Verify.Chert.get_chatrooms(Map.get(session, "user"))
    # s = get_connect_info(session)
    IO.inspect(session, label: "TTTTT")
    userID = Map.get(session, "user")
    {:ok,
    socket
    |> assign(:chatrooms, chatrooms)
    |> assign(:user_id, userID)
    |> assign(:form, to_form(Chatroom.changeset(%Chatroom{}, %{})))
    |> assign(:form2, to_form(UserChatroom.changeset(%UserChatroom{}, %{})))
  }

    # number = Verify.Chert.get_user_reading(1)
    # {:ok, assign(socket, :number, number)}
  end

  def handle_event("redirect", value, socket) do
    val = Map.get(value, "chatroom_id")
    {:noreply, redirect(socket, to: "/chatroom/#{val}/chat")}
  end

  def render(assigns) do
      # ~H"""
      # salam
      # """
       ~H"""
       <%= if assigns[:error] do %>
        <div class="error">
        <%= assigns[:error] %>
      </div>
        <% end %>
      <%!-- <%= connection_info.session %> --%>
      <div style="margin: 30px;">
      <%= for c <- @chatrooms do %>
        <%= live_component(VerifyWeb.Live.ChatroomLive.ChatroomComponent, name: c.name , id: c.id) %>
      <% end %>
      <%!-- Current Number: <%= @chatrooms %> --%>
      </div>
      <div>
      <h3>Create Chatroom</h3>
      <%= live_component(VerifyWeb.ChatroomLive.ChatroomFormComponent, id: @user_id, form: @form) %>
      </div>

      <div style="margin-top: 50px">
      <h3>join Chatroom</h3>
      <%= live_component(VerifyWeb.Live.ChatroomLive.ChatroomSearchComponent, form: @form2, id: 2) %>
      </div>
      """
  end




  def handle_event("save", params , socket) do
    IO.inspect(params, label: "unsigned_params")
    # IO.inspect(socket.assigns.user_id, label: "socket")
    user = Repo.get(User, socket.assigns.user_id)
    IO.inspect(user, label: "user")
    chatroom_name =
    params
    |> Map.get("chatroom")
    |> Map.get("content")
    Repo.insert!(%Chatroom{name: chatroom_name, users: [user] })
    new_chatroom_id = Repo.get_by(Chatroom, name: chatroom_name).id
    {:noreply, redirect(socket, to: "/chatroom/#{new_chatroom_id}/chat")}
    # message = %Message{content: content, user: Repo.get!(User, socket.assigns.user_id), chatroom: Repo.get!(Chatroom, socket.assigns.chatroom_id) }
    # Chert.save_message(message)
    # # redirect(socket, to: "/chatroom/#{socket.assigns.chatroom_id}/chat")
    # {:noreply, socket}
  end

  def handle_event("search", params , socket) do
    # IO.inspect(socket.assigns, label: "socket")
    chatrooms = socket.assigns.chatrooms

    IO.inspect(chatrooms, label: "chatrooms")
    # IO.inspect(socket.assigns.user_id, label: "socket")
    user = Repo.get(User, socket.assigns.user_id)
    chatroom_name = params |> Map.get("user_chatroom") |> Map.get("chatroom_name")
    # chatroom_id = Repo.get_by(Chatroom, name: chatroom_name).id
    case  Repo.get_by(Chatroom, name: chatroom_name) do

        %Chatroom{} = chatroom ->
          query = from(c in UserChatroom, where: c.chatroom_id == ^chatroom.id and c.user_id == ^user.id)
          if Repo.one(query) == nil do
            Repo.insert!(%UserChatroom{user_id: user.id, chatroom_id: chatroom.id})
            {:noreply, redirect(socket, to: "/chatroom/#{chatroom.id}/chat")}
          else
            {:noreply, assign(socket, error: "chatroom already exist")}
          end

        _ -> {:noreply, assign(socket, error: "failed to find chatroom")}

    end

    # IO.inspect(chatroom_id, label: "chatroom_id")
    # {:noreply, socket}
  end

end
