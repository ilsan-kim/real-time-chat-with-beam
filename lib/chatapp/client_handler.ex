defmodule Chatapp.ClientHandler do
  use GenServer
  alias Chatapp.Core.MessageBroadcast

  # API
  def start_link(socket) do
    GenServer.start_link(__MODULE__, socket)
  end

  # GenServer Callbacks
  @impl true
  def init(socket) do
    Chatapp.ClientRegistry.register_client(socket)
    count = Chatapp.ClientRegistry.get_client_count()

    topic = MessageBroadcast.get_topic()
    Phoenix.PubSub.subscribe(Chatapp.PubSub, topic)

    IO.puts("Client connected count: #{count}")

    {:ok, %{socket: socket}}
  end

  @impl true
  def handle_info({:tcp, socket, data}, %{socket: socket} = state) do
    Chatapp.ClientRegistry.broadcast_message(data)
    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp_closed, socket}, %{socket: socket} = state) do
    IO.puts("Client disconnected")
    {:stop, :normal, state}
  end

  @impl true
  def handle_info({:new_message, formatted_message}, %{socket: socket} = state) do
    :gen_tcp.send(socket, formatted_message)
    {:noreply, state}
  end

  @impl true
  def terminate(_reason, %{socket: socket}) do
    Chatapp.ClientRegistry.unregister_client(socket)
    :gen_tcp.close(socket)
    :ok
  end
end
