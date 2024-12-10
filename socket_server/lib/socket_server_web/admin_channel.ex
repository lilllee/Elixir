defmodule SocketServerWeb.AdminChannel do
  use Phoenix.Channel
  alias SocketServerWeb.Presence

  def join("admin:lobby", _message, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  @spec handle_info(:after_join | :list_admin, Phoenix.Socket.t()) ::
          {:noreply, Phoenix.Socket.t()}
  def handle_info(:after_join, socket) do

    cached_msgs = :ets.tab2list(:admin)

    if length(cached_msgs) > 0 do
      Enum.each(cached_msgs, fn {_key, msg} ->
        broadcast!(socket, "admin:lobby", %{
          "user_id" => socket.assigns.user_id,
          "body" => msg
        })
      end)
      :ets.delete_all_objects(:admin)
    end

    {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{
      online_at: inspect(System.system_time(:second))
    })

    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end
end
