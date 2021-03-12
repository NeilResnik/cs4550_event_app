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

  def get_user_name_from_email(email) do
    user = EventApp.Accounts.get_user_by_email(email)
    if user != nil do
      user.name
    else
      email
    end
  end

  def current_user_invited?(conn, event) do
    user = conn.assigns[:current_user]
    if user != nil do
      Enum.any?(event.invites, fn inv -> inv.user_email == user.email end)
    else
      false
    end
  end

  def invited_user?(conn, inv) do
    user = conn.assigns[:current_user]
    if user != nil do
      EventApp.Accounts.get_user_by_email(inv.user_email) == conn.assigns[:current_user]
    else
      false
    end
  end

  def get_inv_changeset(inv) do
    EventApp.Invites.change_invite(inv)
  end
end
