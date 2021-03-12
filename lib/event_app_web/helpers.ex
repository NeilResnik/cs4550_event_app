# Based on Nat Tuck's Lecture Code
# See: https://github.com/NatTuck/scratch-2021-01/blob/master/4550/0302/photo_blog/lib/photo_blog_web/helpers.ex
defmodule EventAppWeb.Helpers do
  alias EventApp.Accounts.User

  def have_current_user?(conn) do
    conn.assigns[:current_user] != nil
  end

  def current_user_id(conn) do
    user = conn.assigns[:current_user]
    user && user.id
  end

  def current_user_is?(conn, %User{} = user) do
    current_user_is?(conn, user.id)
  end

  def current_user_is?(conn, user_id) do
    current_user_id(conn) == user_id
  end
end
