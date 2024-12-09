defmodule SocketServerWeb.PageController do
  use SocketServerWeb, :controller

  @spec home(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
