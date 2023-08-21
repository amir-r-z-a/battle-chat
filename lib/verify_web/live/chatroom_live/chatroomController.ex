defmodule VerifyWeb.Live.ChatroomLive.ChatroomController do
alias VerifyWeb.Live.ChatroomLive.Chatroom

  use VerifyWeb, :controller



  def add(conn, _tom) do
    user = Pow.Plug.current_user(conn)
    case user do
      nil ->
        conn
        |> put_flash(:error, "You must be logged in to access this page")
        |> redirect(to: "/")
      _ ->
        conn
        |> put_session("user", user.id)
        |> Phoenix.LiveView.Controller.live_render(Chatroom)
    end
  end
end
