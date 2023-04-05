defmodule Memz.BestScoresFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Memz.BestScores` context.
  """

  @doc """
  Generate a score.
  """
  def score_fixture(attrs \\ %{}) do
    {:ok, score} =
      attrs
      |> Enum.into(%{
        initials: "some initials",
        score: 42
      })
      |> Memz.BestScores.create_score()

    score
  end
end
