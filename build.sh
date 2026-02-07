# use -i to include a project folder then if there's a folder module, use subfolder.filename

run() {
    echo "$@"
    "$@"
}

LIB_DIR="lib"
LUACC_DIR="$LIB_DIR/luacc"
LUACC="$LUACC_DIR/bin/luacc.lua"

# if the out folder exists, delete it and create a new one, otherwise create a new one
if [ -d "out" ]; then
    rm -rf out
    mkdir out
elif [ ! -d "out" ]; then
    mkdir out
fi

echo "Building the specification library"
run lua $LUACC -o out/specification.lua -i src init rule_registry specification

echo "Build complete! Output is in the out folder."