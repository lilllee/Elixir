defmodule SocketServerWeb.UserSocket do
  use Phoenix.Socket

  channel "user:*", SocketServerWeb.UserChannel
  channel "admin:*", SocketServerWeb.AdminChannel

  @spec connect(nil | map(), Phoenix.Socket.t(), any()) ::
          {:ok, Phoenix.Socket.t()}
  def connect(params, socket, _connect_info) do
    IO.inspect(params)
    {:ok, assign(socket, :user_id, params["user_id"])}
  end

  @spec id(any()) :: <<_::40, _::_*8>>
  def id(socket), do: "user_#{socket.assigns.user_id}"
end
