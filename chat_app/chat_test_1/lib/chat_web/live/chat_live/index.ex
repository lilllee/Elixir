defmodule ChatWeb.ChatLive.Index do
  use ChatWeb, :live_view

  @spec mount(any(), any(), Phoenix.LiveView.Socket.t()) :: {:ok, any()}
  def mount(_params, _session, socket) do
    if connected?(socket) do
      ChatWeb.Endpoint.subscribe(topic())
    end
#    IO.puts("지금 연결된 유저 이름")
#    IO.puts(username())
    {:ok, assign(socket, username: username(), messages: [], topic: topic())}
  end

  @spec handle_info(
          %{
            :event => <<_::56>>,
            :payload => atom() | %{:text => any(), optional(any()) => any()},
            optional(any()) => any()
          },
          atom()
          | %{
              :assigns =>
                atom() | %{:messages => list(), :username => any(), optional(any()) => any()},
              optional(any()) => any()
            }
        ) :: {:noreply, any()}
  def handle_info(%{event: "message", payload: message}, socket) do
    IO.puts(socket.assigns.username)
    IO.puts(message.text)
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [message])}
  end

  @spec handle_event(
          <<_::32>>,
          map(),
          atom()
          | %{
              :assigns => atom() | %{:username => any(), optional(any()) => any()},
              optional(any()) => any()
            }
        ) ::
          {:noreply,
           atom()
           | %{
               :assigns => atom() | %{:username => any(), optional(any()) => any()},
               optional(any()) => any()
             }}
  def handle_event("send",%{"text" => text}, socket) do
    ChatWeb.Endpoint.broadcast(topic(), "message", %{
      text: text,
      name: socket.assigns.username,
    })
    {:noreply, socket}
  end

  defp username do
    "User #{:random.uniform(100)}"
  end

  defp topic do
    "chat"
  end
end
