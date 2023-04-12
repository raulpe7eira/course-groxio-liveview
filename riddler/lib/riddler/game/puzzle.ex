defmodule Riddler.Game.Puzzle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "puzzles" do
    field :height, :integer
    field :name, :string
    field :width, :integer

    timestamps()
  end

  @doc false
  def changeset(puzzle, attrs) do
    puzzle
    |> cast(attrs, [:name, :height, :width])
    |> validate_required([:name, :height, :width])
  end
end
