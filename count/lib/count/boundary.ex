defmodule Count.Boundary do
  alias Ecto.Changeset

  def add(counters, changeset) do
    counters
    |> Map.put(
      Changeset.fetch_field!(changeset, :name),
      Changeset.fetch_field!(changeset, :count)
    )
  end
end
