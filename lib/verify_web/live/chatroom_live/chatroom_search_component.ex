defmodule VerifyWeb.Live.ChatroomLive.ChatroomSearchComponent do

  use VerifyWeb, :live_component
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <div>
    <.form for={@form}  phx-submit="search">
    <.input type="text" field={@form[:chatroom_name]} />
    <button>search</button>
    </.form>
    </div>
    """
  end

end
