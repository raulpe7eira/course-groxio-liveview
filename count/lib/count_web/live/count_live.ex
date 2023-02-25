defmodule CountWeb.CountLive do
  use CountWeb, :live_view

  alias Count.Core
  alias CountWeb.Counter
  alias CountWeb.Heading

  # c - constructor

  def mount(_params, _session, socket) do
    :timer.send_interval(1_000, :tick)
    {:ok, init_counters(socket)}
  end

  # r - reducers

  # see `counter.ex` instead of `handle_*` function

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

  # private functions

  defp init_counters(socket) do
    assign(socket, counters: Core.new(~w[lions tigers bears]))
  end
end
