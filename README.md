# Super Simple Real-Time TCP Chat Server built on BEAM

## What is it?
Connect multiple clients via TCP and Chat in real-time. Messages are instantly broadcast to all connected clients.

## How to use it?
```bash
# Run Server
mix deps.get
mix run --no-halt

# Connect to Server
telnet localhost 4040
nc localhost 4040
```
