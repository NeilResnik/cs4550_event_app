defmodule EventApp.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string, null: false
      add :date, :date , null: false
      add :description, :string, null: false

      timestamps()
    end

  end
end
