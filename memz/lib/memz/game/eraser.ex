defmodule Memz.Game.Eraser do
  # mode: finished, guessing, erasing
  defstruct ~w[text schedule score initial_text status]a
  @delete_proof ["\n", ",", "."]

  def new(text, steps) do
    %__MODULE__{
      text: text,
      schedule: schedule(text, steps),
      score: 0,
      initial_text: text,
      status: :erasing
    }
  end

  def erase(%{schedule: [to_erase | rest], text: text} = eraser) do
    erased =
      text
      |> String.graphemes()
      |> Enum.with_index(1)
      |> Enum.map(fn {char, index} -> maybe_erase(char, index in to_erase) end)
      |> Enum.join("")

    %{eraser | schedule: rest, text: erased, status: :guessing}
  end

  def score(eraser, guess) do
    compute_score(eraser, guess)
    |> set_next_status()
  end

  defp compute_score(eraser, guess) do
    score_difference =
      eraser.initial_text
      |> String.myers_difference(guess)
      |> Enum.reject(fn {edit, _string} -> edit == :eq end)
      |> Enum.map(fn {_edit, string} -> string end)
      |> Enum.join()
      |> String.length()

    %{eraser | score: eraser.score + score_difference}
  end

  defp set_next_status(%{schedule: []} = eraser) do
    %{eraser | status: :finished}
  end

  defp set_next_status(eraser) do
    %{eraser | status: :erasing}
  end

  defp schedule(text, steps) do
    size = String.length(text)

    chunk_size =
      size
      |> Kernel./(steps)
      |> ceil

    1..size
    |> Enum.shuffle()
    |> Enum.chunk_every(chunk_size)
  end

  defp maybe_erase(char, _test) when char in @delete_proof, do: char
  defp maybe_erase(_char, true), do: "_"
  defp maybe_erase(char, false), do: char

  def done?(%{status: :finished}), do: true
  def done?(_eraser), do: false
end
