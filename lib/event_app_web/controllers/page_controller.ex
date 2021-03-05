defmodule EventAppWeb.PageController do
  use EventAppWeb, :controller

  alias EventApp.Events

  def index(conn, _params) do
    events = Events.list_events()
    IO.inspect events
    render(conn, "index.html", events: events)
  end
end
