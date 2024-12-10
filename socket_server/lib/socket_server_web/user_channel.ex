defmodule SocketServerWeb.UserChannel do
  use Phoenix.Channel
  alias SocketServerWeb.Presence

  def join("user:lobby", _message, socket) do
    {:ok, socket}
  end

  def handle_in("send_message", %{"body" => body}, socket) do
    if Presence.list("admin:lobby") |> map_size() === 0 do
      :ets.insert(:admin, {:"msg_#{:os.system_time(:millisecond)}", body})
    else
      broadcast!(socket, "admin:lobby", %{"user_id" => socket.assigns.user_id, "body" => body})
    end

    {:noreply, socket}
  end

end
