defmodule Chatapp.Core.MessageBroadcast do
  @topic "chat_messages"

  def get_topic, do: @topic

  def format_message(raw_message) do
    "[broadcast] #{String.trim(raw_message)}\n"
  end

  def prepare_publish_data(message) do
    %{
      topic: @topic,
      formatted_message: format_message(message)
    }
  end

  def prepare_broadcast(client_sockets, message) when is_list(client_sockets) do
    formatted_message = format_message(message)
    Enum.map(client_sockets, &{&1, formatted_message})
  end
end
