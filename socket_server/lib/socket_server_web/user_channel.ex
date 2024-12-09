defmodule SocketServerWeb.UserChannel do
  use Phoenix.Channel
  alias SocketServerWeb.Presence

  def join("user:lobby", _message, socket) do
    IO.puts("User joined: #{socket.assigns.user_id}")
    send(self(), :after_join)
    IO.puts("User joined: #{socket.assigns.user_id}")
    {:ok, socket}
  end

  @spec handle_in(<<_::96>>, map(), Phoenix.Socket.t()) :: {:noreply, Phoenix.Socket.t()}
  def handle_in("send_message", %{"body" => body}, socket) do
    broadcast!(socket, "user_message", %{"user_id" => socket.assigns.user_id, "body" => body})
    {:noreply, socket}
  end

  def handle_in("admin_list", _, socket) do
    send(self(), :list_admin)
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{
      online_at: inspect(System.system_time(:second))
    })
    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket |> IO.inspect()}
  end

  def handle_info(:list_admin, socket) do
    Presence.list("user:lobby") |> IO.inspect()
    {:noreply, socket}
  end
end
