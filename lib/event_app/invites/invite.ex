defmodule EventApp.Invites.Invite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invites" do
    field :status, Ecto.Enum, values: [:yes, :no, :maybe, :no_response]
    field :user_email, :string
    belongs_to :event, EventApp.Events.Event

    timestamps()
  end

  @doc false
  def changeset(invite, attrs) do
    invite
    |> cast(attrs, [:user_email, :status, :event_id])
    |> validate_required([:user_email, :status, :event_id])
  end
end
