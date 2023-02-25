defmodule Count.Boundary do
  alias Count.Core
  alias Count.Tally
  alias Ecto.Changeset

  defdelegate new_counter(counter_names),
    to: Core,
    as: :new

  defdelegate inc(counters, counter_name),
    to: Core,
    as: :inc

  def validate(counters, used_names) do
    counters
    |> Tally.validate(used_names)
    |> Map.put(:action, :insert)
  end

  def add(counters, params, used_names) do
    changeset = validate(params, used_names)

    do_add(counters, changeset)
  end

  defp do_add(counters, %{valid?: false}),
    do: counters

  defp do_add(counters, changeset) do
    name = Changeset.fetch_field!(changeset, :name)
    count = Changeset.fetch_field!(changeset, :count)

    Core.add(counters, name, count)
  end
end
