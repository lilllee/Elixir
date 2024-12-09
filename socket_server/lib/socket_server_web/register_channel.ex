defmodule SocketServerWeb.RegisterChannel do
  use Phoenix.Channel

  @spec join(<<_::112>>, any(), any()) :: {:ok, any()}
  def join("register:lobby", _message, socket) do
    {:ok, socket}
  end

  @spec handle_in(<<_::56>>, map(), Phoenix.Socket.t()) :: {:noreply, Phoenix.Socket.t()}
  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast!(socket, "new_msg", %{"body" => body})
    {:noreply, socket |> inspect()}
  end

  def handle_in("call_notification", %{"content" => _content}, socket) do
    {:noreply, socket}
  end
end
