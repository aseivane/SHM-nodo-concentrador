#!/bin/bash
echo "Initializing SHM server"
echo "Making E-SIC"
cd E-SIC/client-server
make

echo "Make complete"
echo "Running E-SIC server"
./server &

cd ../..
cd SHM-website
echo "Installing Node.js modules"
npm install
echo "Running webserver"
nodejs app.js &



