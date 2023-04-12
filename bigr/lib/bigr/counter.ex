defmodule Bigr.Counter do
  defstruct [:count]

  def new(string \\ "0") do
    %__MODULE__{count: String.to_integer(string)}
  end

  def inc(counter, by \\ 1) do
    %__MODULE__{counter | count: counter.count + by}
  end

  def show(counter) do
    counter.count
  end
end
