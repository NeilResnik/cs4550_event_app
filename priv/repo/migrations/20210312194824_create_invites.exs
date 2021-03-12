defmodule EventApp.Repo.Migrations.CreateInvites do
  use Ecto.Migration

  def change do
    create table(:invites) do
      add :user_email, :text, null: false
      add :status, :text, null: false
      add :event_id, references(:events, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:invites, [:event_id])
  end
end
