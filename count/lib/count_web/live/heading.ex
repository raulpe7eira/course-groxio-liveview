defmodule CountWeb.Heading do
  use Phoenix.Component

  def one(assigns) do
    ~H"""
    <h1><%= @message %></h1>
    """
  end

  def two(assigns) do
    ~H"""
    <h2><%= @message %></h2>
    """
  end
end
