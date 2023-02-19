defmodule DazzleWeb.TickerLive do
  use DazzleWeb, :live_view

  def mount(_params, _session, socket) do
    :timer.send_interval(250, self(), :tick)
    {:ok, assign(socket, count: 20)}
  end

  def render(assigns) do
    style = """
    transform: rotate(#{assigns.count}deg);
               text-align: center;
               width: 400px;
    """

    ~H"""
    <br><br><br><br><br><br><br><br><br>
    <h1>Dazzle count: <%= @count %></h1>

    <br><br><br><br><br><br><br><br><br>

    <pre style={style}>
      <h2>Rotated</h2>
    </pre>
    <br><br><br><br><br><br><br><br><br>
    <pre>
      <h2 style="text-align: center;"><%= scrolled("scrolled", @count) %></h2>
    </pre>
    """
  end

  def handle_info(:tick, socket) do
    {:noreply, inc(socket)}
  end

  defp scrolled(string, count) do
    split_point = rem(count, 40)
    message = padded_message(string, count)

    message
    |> Enum.drop(split_point)
    |> Kernel.++(Enum.take(message, split_point))
    |> to_string
    |> Phoenix.HTML.raw()
  end

  defp padded_message(string, _count) do
    spaces = List.duplicate(32, 40)

    string
    |> String.to_charlist()
    |> Kernel.++(spaces)
    |> Enum.take(60)
  end

  defp inc(socket) do
    assign(socket, count: socket.assigns.count + 1)
  end
end
