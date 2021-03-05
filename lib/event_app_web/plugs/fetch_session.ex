# based on Nat Tuck's Lecture Notes and Example Code
# See:
# https://github.com/NatTuck/scratch-2021-01/blob/master/notes-4550/11-photoblog/notes.md
# https://github.com/NatTuck/scratch-2021-01/blob/master/4550/0223/photo_blog/lib/photo_blog_web/plugs/fetch_user.ex
defmodule EventAppWeb.Plugs.FetchUser do
  import Plug.Conn

  def init(args), do: args

  def call(conn, _args) do
    user_id = get_session(conn, :user_id) || -1
    user = PhotoBlog.Users.get_user(user_id)
    if user do
      assign(conn, :current_user, user)
    else
      assign(conn, :current_user, nil)
    end
  end

  # conn.assigns[:current_user]
  # <%= @current_user.name %>
end
