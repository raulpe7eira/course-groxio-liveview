defmodule CountWeb.CountLive do
  use CountWeb, :live_view

  alias CountWeb.Counter
  alias CountWeb.Heading

  # c - constructor

  def mount(_params, _session, socket) do
    :timer.send_interval(1_000, :tick)
    {:ok, socket}
  end

  # r - reducers

  def handle_info(:tick, socket) do
    send_update(Counter, id: "counters", adding: socket.assigns.live_action != :index, tick: true)
    {:noreply, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  # see `counter.ex` instead of other `handle_*` functions

  # def handle_info(:tick, socket) do
  #   {:noreply, inc(socket)}
  # end

  # def handle_event("inc", _params, socket) do
  #   {:noreply, inc(socket)}
  # end

  # c - converter

  # see `count_live.html.heex` instead of `render` function

  # def render(assigns) do
  #   ~H"""
  #   <h1>Hello, <%= @hello %>!</h1>
  #   <h2>If you dream it, we can count it.</h2>
  #   <p>Your count: <%= @counter.count %></p>
  #   <button phx-click={ :inc }>Inc</button>
  #   """
  # end
end
