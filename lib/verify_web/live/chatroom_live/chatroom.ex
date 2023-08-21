defmodule VerifyWeb.Live.ChatroomLive.Chatroom do
  use Phoenix.LiveView

  def mount(_params, session ,socket) do
    # IO.inspect(get_connect_info(socket))
    chatrooms = Verify.Chert.get_chatrooms(Map.get(session, "user"))
    # s = get_connect_info(session)
    IO.inspect(session, label: "TTTTT")
    {:ok, assign(socket, :chatrooms, chatrooms)}

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
      <%= for c <- @chatrooms do %>
        <%= live_component(VerifyWeb.Live.ChatroomLive.ChatroomComponent, name: c.name , id: c.id) %>
      <% end %>
      <%!-- Current Number: <%= @chatrooms %> --%>
      """
  end

end
