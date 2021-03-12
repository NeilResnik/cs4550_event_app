defmodule EventAppWeb.EventController do
  use EventAppWeb, :controller

  alias EventApp.Events
  alias EventApp.Events.Event
  alias EventApp.Comments
  alias EventApp.Invites
  alias EventAppWeb.Helpers
  alias EventAppWeb.Plugs

  # Based on Nat Tucks Lecture Code
  # See: https://github.com/NatTuck/scratch-2021-01/blob/master/4550/0302/photo_blog/lib/photo_blog_web/controllers/post_controller.ex
  plug Plugs.RequireUser when action in [:new, :edit, :create, :update]
  plug :fetch_post when action in [:show, :edit, :update, :delete]
  plug :require_owner when action in [:edit, :update, :delete]

  def fetch_post(conn, _args) do 
    id = conn.params["id"]
    event = Events.get_event!(id)
    assign(conn, :event, event)
  end

  def require_owner(conn, _args) do
    # We must have these assigns or things break
    user = conn.assigns[:current_user]
    event = conn.assigns[:event]
    if user.id == event.user_id do
      conn
    else
      conn
      |> put_flash(:error, "Must be creator to do that action!")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  def invitee(conn, %{"event_id" => id}) do
    user = conn.assigns[:current_user]
    if user == nil do
      redirect(conn, to: Routes.user_path(conn, :new))
      |> redirect(to: Routes.event_path(conn, :show, id))
      |> halt()
    else
      redirect(conn, to: Routes.event_path(conn, :show, id))
    end
  end


  def index(conn, _params) do
    events = Events.list_events()
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = Events.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    event_params = event_params
                   |> Map.put("user_id", conn.assigns[:current_user].id)
    case Events.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => _id}) do
    event = conn.assigns[:event]
            |> Events.load_comments()
            |> Events.load_invites()
    comm = %Comments.Comment{
      event_id: event.id,
      user_id: Helpers.current_user_id(conn)
    }
    inv = %Invites.Invite{
      event_id: event.id,
      status: :no_response,
    }
    new_comment = Comments.change_comment(comm)
    new_invite = Invites.change_invite(inv)
    render(conn, "show.html", event: event, new_comment: new_comment, new_invite: new_invite)
  end

  def edit(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    changeset = Events.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Events.get_event!(id)

    case Events.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    {:ok, _event} = Events.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: Routes.event_path(conn, :index))
  end
end
