defmodule Memz.PassagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Memz.Passages` context.
  """

  @doc """
  Generate a reading.
  """
  def reading_fixture(attrs \\ %{}) do
    {:ok, reading} =
      attrs
      |> Enum.into(%{
        name: "some name",
        passage: "some passage",
        steps: 42
      })
      |> Memz.Passages.create_reading()

    reading
  end
end
