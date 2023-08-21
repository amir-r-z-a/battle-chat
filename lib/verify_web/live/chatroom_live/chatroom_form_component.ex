defmodule VerifyWeb.ChatroomLive.ChatroomFormComponent do
  use VerifyWeb, :live_component
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <div>
    <.form for={@form}  phx-submit="save">
    <.input type="text" field={@form[:content]} />
    <button>Save</button>
    </.form>
    </div>
    """
  end
end
