defmodule Chatapp.ClientRegistry do
  use GenServer
  alias Chatapp.Core.MessageBroadcast

  # API
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def register_client(socket) do
    GenServer.cast(__MODULE__, {:register_client, socket})
  end

  def broadcast_message(message) do
    GenServer.cast(__MODULE__, {:broadcast_message, message})
  end

  def unregister_client(socket) do
    GenServer.cast(__MODULE__, {:unregister_client, socket})
  end

  def get_client_count do
    GenServer.call(__MODULE__, :get_client_count)
  end

  # GenServer Callbacks
  @impl true
  def init(_) do
    {:ok, []}
  end

  @impl true
  def handle_cast({:register_client, socket}, clients) do
    {:noreply, [socket | clients]}
  end

  @impl true
  def handle_cast({:broadcast_message, message}, state) do
    %{topic: topic, formatted_message: formatted_message} =
      MessageBroadcast.prepare_publish_data(message)

    Phoenix.PubSub.broadcast(Chatapp.PubSub, topic, {:new_message, formatted_message})
    {:noreply, state}
  end

  @impl true
  def handle_cast({:unregister_client, socket}, clients) do
    {:noreply, List.delete(clients, socket)}
  end

  @impl true
  def handle_call(:get_client_count, _from, clients) do
    {:reply, length(clients), clients}
  end
end
