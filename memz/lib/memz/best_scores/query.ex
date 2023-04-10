defmodule Memz.BestScores.Query do
  import Ecto.Query, warn: false

  alias Memz.BestScores.Score

  def top_scores(reading_id, limit) do
    from s in Score,
      select: {s.initials, s.score},
      where: s.reading_id == ^reading_id,
      order_by: [asc: :score],
      limit: ^limit
  end
end
