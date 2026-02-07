#!/bin/bash

run() {
    echo "$@"
    "$@"
}

# Parse arguments
ROOT_DIR="."
OUTPUT_DIR="out"
while [[ $# -gt 0 ]]; do
    case $1 in
        --root-dir)
            ROOT_DIR="$2"
            shift 2
            ;;
        --output-dir|-o)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

OUTPUT_DIR="$ROOT_DIR/$OUTPUT_DIR"

LIB_DIR="$ROOT_DIR/lib"
LUACC_DIR="$LIB_DIR/luacc"
LUACC="$LUACC_DIR/bin/luacc.lua"

# if the out folder exists, delete it and create a new one, otherwise create a new one
if [ -d "$OUTPUT_DIR" ]; then
    rm -rf "$OUTPUT_DIR"
    mkdir "$OUTPUT_DIR"
elif [ ! -d "$OUTPUT_DIR" ]; then
    mkdir "$OUTPUT_DIR"
fi

echo "Building the specification library"
run lua $LUACC -o "$OUTPUT_DIR/specification.lua" -i src init rule_registry specification

echo "Build complete! Output is in the $OUTPUT_DIR folder."