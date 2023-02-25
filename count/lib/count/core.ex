defmodule Count.Core do
  def new(counter_names) do
    for counter_name <- counter_names, into: %{} do
      {counter_name, 0}
    end
  end

  def add(counters, counter_name, counter_count) do
    Map.put(counters, counter_name, counter_count)
  end

  def inc(counters, counter_name) do
    Map.put(counters, counter_name, counters[counter_name] + 1)
  end
end
