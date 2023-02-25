defmodule Count.Core do
  def new(keys \\ ["lions"]) do
    for key <- keys, into: %{} do
      {key, 0}
    end
  end

  def inc(counter, key \\ "lions") do
    Map.put(counter, key, counter[key] + 1)
  end
end
