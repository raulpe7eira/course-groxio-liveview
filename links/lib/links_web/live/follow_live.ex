defmodule LinksWeb.FollowLive do
  use LinksWeb, :live_view

  def mount(_params, _session, socket) do
    Process.sleep(300)

    {:ok, follow(socket, {:mount, connected?(socket)})}
  end

  def render(assigns) do
    ~H"""
    <h1>Hello, world!</h1>

    <pre><%= @follows |> Enum.reverse |> inspect %></pre>

    <hr />

    <.link href={~p"/follow"}>http</.link>
    <.link patch={~p"/follow"}>patch</.link>
    <.link navigate={~p"/follow"}>navigate</.link>
    """
  end

  def handle_params(_, _url, socket) do
    {:noreply, follow(socket, {:handle_params, connected?(socket)})}
  end

  defp follow(socket, data) do
    follows = Map.get(socket.assigns, :follows) || []
    assign(socket, follows: [data | follows])
  end
end
