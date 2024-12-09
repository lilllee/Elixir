defmodule SocketServerWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :socket_server

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_socket_server_key",
    signing_salt: "QUjnO38f",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket,
    websocket: true,
    longpoll: false

  socket "/socket", SocketServerWeb.UserSocket,
    websocket: [
      url: [host: "192.168.1.29", port: 4000],
      transport_options: [socket_opts: [:inet6]],
      # SSL 설정 추가
      certfile: "priv/cert/selfsigned.pem",
      keyfile: "priv/cert/selfsigned_key.pem"
    ]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :socket_server,
    gzip: false,
    only: SocketServerWeb.static_paths()

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug SocketServerWeb.Router
end
