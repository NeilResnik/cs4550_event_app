# Based on Nat Tuck's Lecture Notes and Code
# See:
# https://github.com/NatTuck/scratch-2021-01/blob/master/notes-4550/11-photoblog/notes.md
# https://github.com/NatTuck/scratch-2021-01/blob/master/4550/0223/photo_blog/lib/photo_blog_web/controllers/session_controller.ex
defmodule EventAppWeb.SessionController do
  use EventAppWeb, :controller

  def create(conn, %{"name" => name}) do
    user = EventApp.Accounts.get_user_by_email(name)
    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome back #{user.name}")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Login failed.")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
