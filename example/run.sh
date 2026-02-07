#!/bin/bash

if [ ! -d "../out" ]; then
    # Build the specification library first
    cd .. > /dev/null && make build && cd - > /dev/null
fi

# Run the example with LUA_PATH pointing to the built library
export LUA_PATH="../out/?.lua;../src/?.lua;./?.lua;;"

lua main.lua
