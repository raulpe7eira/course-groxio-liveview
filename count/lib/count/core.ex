defmodule Count.Core do
  def new(keys \\ [:count]) do
    for key <- keys, into: %{} do
      {key, 0}
    end
  end

  def inc(counter, key \\ :count) do
    Map.put(counter, key, counter[key] + 1)
  end
end
