defmodule SocketServerWeb.Presence do
  use Phoenix.Presence,
    otp_app: :socket_server,
    pubsub_server: SocketServer.PubSub
end
