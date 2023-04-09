defmodule Memz.Passages do
  @moduledoc """
  The Passages context.
  """

  import Ecto.Query, warn: false
  alias Memz.Repo

  alias Memz.Passages.Reading

  @doc """
  Returns the list of readings.

  ## Examples

      iex> list_readings()
      [%Reading{}, ...]

  """
  def list_readings do
    Repo.all(Reading)
  end

  def get_first_reading() do
    from(r in Reading,
      order_by: [desc: :name],
      limit: 1
    )
    |> Repo.all()
    |> List.first()
  end

  def next_passage(name) do
    compute_next_passage(reading_names(), name)
  end

  def previous_passage(name) do
    reading_names()
    |> Enum.reverse()
    |> compute_next_passage(name)
  end

  defp reading_names do
    from(r in Reading,
      select: r.name,
      order_by: [desc: :name]
    )
    |> Repo.all()
  end

  defp compute_next_passage(_names, nil), do: nil

  defp compute_next_passage(names, passage_name) do
    names
    |> Enum.drop_while(fn name -> name != passage_name end)
    |> Enum.drop(1)
    |> List.first()
    |> Kernel.||(List.first(names))
  rescue
    _err -> nil
  end

  def lookup_reading(name) do
    from(r in Reading,
      where: r.name == ^name
    )
    |> Repo.all()
    |> List.first()
  end

  @doc """
  Gets a single reading.

  Raises `Ecto.NoResultsError` if the Reading does not exist.

  ## Examples

      iex> get_reading!(123)
      %Reading{}

      iex> get_reading!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reading!(id), do: Repo.get!(Reading, id)

  @doc """
  Creates a reading.

  ## Examples

      iex> create_reading(%{field: value})
      {:ok, %Reading{}}

      iex> create_reading(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reading(attrs \\ %{}) do
    %Reading{}
    |> Reading.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reading.

  ## Examples

      iex> update_reading(reading, %{field: new_value})
      {:ok, %Reading{}}

      iex> update_reading(reading, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reading(%Reading{} = reading, attrs) do
    reading
    |> Reading.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reading.

  ## Examples

      iex> delete_reading(reading)
      {:ok, %Reading{}}

      iex> delete_reading(reading)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reading(%Reading{} = reading) do
    Repo.delete(reading)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reading changes.

  ## Examples

      iex> change_reading(reading)
      %Ecto.Changeset{data: %Reading{}}

  """
  def change_reading(%Reading{} = reading, attrs \\ %{}) do
    Reading.changeset(reading, attrs)
  end
end
