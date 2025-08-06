defmodule Chatapp.TcpServer do
  def start(port) do
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [
        :binary,
        packet: :line,
        active: false,
        reuseaddr: true,
        backlog: 65536
      ])

    IO.puts("Chat server listening on port #{port}")
    accept_loop(listen_socket)
  end

  defp accept_loop(listen_socket) do
    {:ok, socket} = :gen_tcp.accept(listen_socket)
    {:ok, handler_pid} = Chatapp.ClientHandler.start_link(socket)
    :gen_tcp.controlling_process(socket, handler_pid)
    :inet.setopts(socket, active: true)
    accept_loop(listen_socket)
  end
end
