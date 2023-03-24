#!/bin/bash

# Make sure Docker is running first

# Start the backend 
make -C backend d.up && sleep 1
make -C backend db.update

make -C backend build
backend/out/bin/harbour-api&
echo $! > server.pid

# Start the frontend
cd harbour_frontend && flutter run

# Stop
cd ..
kill $(cat server.pid)
make -C backend d.down
rm server.pid
