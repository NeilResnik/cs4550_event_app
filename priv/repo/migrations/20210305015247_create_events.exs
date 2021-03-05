defmodule EventApp.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :date, :date
      add :description, :string

      timestamps()
    end

  end
end
