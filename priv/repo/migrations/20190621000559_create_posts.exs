defmodule Nilm.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :text
      add :author_id, references(:users)
      timestamps()
    end
  end
end
