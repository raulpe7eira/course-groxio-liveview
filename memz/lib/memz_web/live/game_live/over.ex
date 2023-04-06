defmodule MemzWeb.GameLive.Over do
  use MemzWeb, :live_view

  def mount(%{"score" => score}, _session, socket) do
    {:ok, assign(socket, score: score)}
  end

  def render(assigns) do
    ~L"""
    <h1>Game over!</h1>
    <h2>Your score: <%= @score %></h2>
    <button phx-click="play">Play again?</button>
    """
  end

  def handle_event("play", _meta, socket) do
    {:noreply, push_redirect(socket, to: "/game/play")}
  end
end
