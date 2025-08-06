defmodule Chatapp.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: Chatapp.PubSub},
      {Chatapp.ClientRegistry, []},
      {Task, fn -> Chatapp.TcpServer.start(4040) end}
    ]

    opts = [strategy: :one_for_one, name: Chatapp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
