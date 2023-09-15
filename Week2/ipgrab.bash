#!/bin/bash

echo $(ip addr | awk '/inet / {print $2}' | grep -v "127.0.0.1")

echo "Your IP is: $ip_address"
