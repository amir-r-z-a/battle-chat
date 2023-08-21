defmodule VerifyWeb.Live.ChatLive.Chat do
  alias Verify.{Message, Users.User, Chatroom, Repo, Chert}
  use Phoenix.LiveView

  # use VerifyWeb, :live_component


  def mount(params, session ,socket) do
    IO.inspect(params, label: "params")
    chatroom_id = Map.get(params, "id")
    IO.inspect(chatroom_id, label: "chatroom_id")
    chats = Verify.Chert.get_messages(chatroom_id)
    IO.inspect(session, label: "session")
    userID = Map.get(session, "user")
    if connected?(socket), do: Chert.subscribe(chatroom_id)
    {:ok, socket
    |> assign(:user_id, userID)
    |> assign(:chatroom_id, chatroom_id)
    |> assign(:form, to_form(Message.changeset(%Message{}, %{})))
    |> assign(:chats, chats)}

  end

  # def handle_event("validate", %{"message" => params}, socket) do
  #   form =
  #     %Message{}
  #     |> Message.changeset(params)
  #     |> Map.put(:action, :insert)
  #     |> to_form()

  #   {:noreply, assign(socket, form: form)}
  # end




  # def handle_event("save", %{"user" => user_params}, socket) do
  #   IO.inspect(user_params, label: "user_params")
  #   {:noreply, socket}
  #   # case Accounts.create_user(user_params) do
  #   #   {:ok, user} ->
  #   #     {:noreply,
  #   #      socket
  #   #      |> put_flash(:info, "user created")
  #   #      |> redirect(to: ~p"/users/#{user}")}

  #   #   {:error, %Ecto.Changeset{} = changeset} ->
  #   #     {:noreply, assign(socket, form: to_form(changeset))}
  #   # end
  # end





  def render(assigns) do
    ~H"""
      <%!-- <%=IO.inspect(@chats, label: "assigns")%> --%>
      <%= for m <- @chats do %>
        <%= live_component(VerifyWeb.Live.ChatLive.ChatComponent, content: m.content ,
        id: m.id,
        user_number: m.user.number,
        chat_user_id: m.user.id,
        user_id: @user_id
        ) %>
      <% end %>

      <%= live_component(VerifyWeb.Live.ChatLive.FormComponent, id: @user_id, form: @form) %>
    """
  end



  def handle_event("save", params , socket) do
    IO.inspect(socket.assigns, label: "unsigned_params")
    content =
    params
    |> Map.get("message")
    |> Map.get("content")
    # Repo.insert!(%Message{content: content, user: Repo.get!(User, socket.assigns.user_id), chatroom: Repo.get!(Chatroom, socket.assigns.chatroom_id) })
    message = %Message{content: content, user: Repo.get!(User, socket.assigns.user_id), chatroom: Repo.get!(Chatroom, socket.assigns.chatroom_id) }
    Chert.save_message(message)
    # redirect(socket, to: "/chatroom/#{socket.assigns.chatroom_id}/chat")
    {:noreply, socket}
  end

# @impl true
  def handle_info({:new_message, _message}, socket) do
    IO.inspect(socket.assigns, label: "handle_info")
    {:noreply, socket |> assign(:chats, Chert.get_messages(socket.assigns.chatroom_id))}
  end


end
