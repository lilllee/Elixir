defmodule SocketServerWeb.UserSocket do
  use Phoenix.Socket

  channel "register:*", SocketServerWeb.RegisterChannel

  @spec connect(nil | maybe_improper_list() | map(), Phoenix.Socket.t(), any()) ::
          {:ok, Phoenix.Socket.t()}
  def connect(params, socket, _connect_params) do
    {:ok, assign(socket |> IO.inspect(), :user_id, params["user_id"])}
  end

  @spec id(any()) :: <<_::48, _::_*8>>
  def id(socket), do: "users_#{socket.assigns.user_id}"

end
