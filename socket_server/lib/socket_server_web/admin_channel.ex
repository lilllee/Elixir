defmodule SocketServerWeb.AdminChannel do
  use Phoenix.Channel

  def join("admin:lobby", _message, socket) do
    IO.puts("Admin joined: #{socket.assigns.user_id}")
    {:ok, socket}
  end

  def handle_in("send_message", %{"body" => body}, socket) do
    IO.puts("Message from admin #{socket.assigns.user_id}: #{body}")

    broadcast!(socket, "admin_message", %{"admin_id" => socket.assigns.user_id, "body" => body})

    {:noreply, socket}
  end
end
