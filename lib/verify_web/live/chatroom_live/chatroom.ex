defmodule VerifyWeb.Live.ChatroomLive.Chatroom do

  alias Verify.{Users.User,Chatroom, Repo}
  use Phoenix.LiveView

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
      <%= live_component(VerifyWeb.ChatroomLive.ChatroomFormComponent, form: @form) %>
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
    # message = %Message{content: content, user: Repo.get!(User, socket.assigns.user_id), chatroom: Repo.get!(Chatroom, socket.assigns.chatroom_id) }
    # Chert.save_message(message)
    # # redirect(socket, to: "/chatroom/#{socket.assigns.chatroom_id}/chat")
    {:noreply, socket}
  end

end
