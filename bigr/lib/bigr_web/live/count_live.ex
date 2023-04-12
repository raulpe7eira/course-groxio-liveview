defmodule BigrWeb.CountLive do
  use BigrWeb, :live_view

  alias BigrWeb.CountLive

  def render(assigns) do
    ~H"""
    <h1 class="text-4xl">Game Night Scores!</h1>
    <.game_grid>
      <%= for t <- 1..12 do %>
        <.live_component id={"table-#{t}"} module={CountLive.Counter} table_number={t} />
      <% end %>
    </.game_grid>
    """
  end

  slot :inner_block

  defp game_grid(assigns) do
    ~H"""
    <div class="grid grid-cols-3 gap-4">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
