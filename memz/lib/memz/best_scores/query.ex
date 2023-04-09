defmodule Memz.BestScores.Query do
  import Ecto.Query, warn: false

  alias Memz.BestScores.Score

  def top_scores(limit) do
    from s in Score,
      select: {s.initials, s.score},
      order_by: [asc: :score],
      limit: ^limit
  end
end
