defmodule Count.Tally do
  import Ecto.Changeset

  @types %{name: :string, count: :integer}
  defstruct name: "", count: 0

  def new, do: __struct__()
  def new(opts), do: __struct__(opts)

  def validate(params, used_names) do
    {new(), @types}
    |> cast(params, Map.keys(@types))
    |> validate_required(:name)
    |> validate_exclusion(:name, used_names)
    |> validate_number(:count, greater_than: -1)
  end
end
