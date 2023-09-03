defmodule VerifyWeb.Live.ChatLive.ChatComponent do
  use VerifyWeb, :live_component


  def render(assigns) do

    ~H"""
    <div>
          <%= if @user_id == @chat_user_id do %>
            <div style="margin: 60px 600PX;" >
              <h3 style="color: red" >ME</h3>
              <p style="color: blue"><%= @content %></p>
            </div>
          <% else %>
          <%= if not @is_private do %>
            <div style="margin: 60PX " >
              <h3 style="color:red" ><%= @user_number %></h3>
              <p style="color:blue"><%= @content %></p>
            </div>
          <% end %>
          <% end %>
    </div>
    """
  end

end
