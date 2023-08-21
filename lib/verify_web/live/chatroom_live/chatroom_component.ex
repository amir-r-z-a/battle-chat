defmodule VerifyWeb.Live.ChatroomLive.ChatroomComponent do
  use VerifyWeb, :live_component


  def mount(socket) do
    IO.inspect("Hello")
    {:ok, socket}
  end

  def render(assigns) do

    ~H"""
          <div>
            <button phx-click="redirect" phx-value-chatroom_id={@id}  ><%= @name %></button>
          </div>
    """
  end

end
