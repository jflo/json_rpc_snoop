#!/bin/sh


./json_rpc_snoop "http://host.docker.internal:8551" -b 0.0.0.0 --port 8551 &
./json_rpc_snoop "http://host.docker.internal:8545" -b 0.0.0.0 --port 8545

