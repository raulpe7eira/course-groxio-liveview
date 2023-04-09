defmodule Memz.Repo.Migrations.CreateReadings do
  use Ecto.Migration

  def change do
    create table(:readings) do
      add :name, :string
      add :passage, :text
      add :steps, :integer

      timestamps()
    end
  end
end
