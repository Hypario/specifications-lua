.PHONY: test build clean help

OUT_DIR ?= out

help:
	@echo "Available targets:"
	@echo "  make test    - Run all unit tests"
	@echo "  make build   - Build the specification library (OUT_DIR=out by default)"
	@echo "  make clean   - Remove build artifacts"
	@echo ""
	@echo "Examples:"
	@echo "  make build                    # Output to ./out"
	@echo "  make build OUT_DIR=/tmp/dist  # Output to /tmp/dist"

test:
	@busted test

build:
	@echo "Building the specification library"
	@mkdir -p $(OUT_DIR)
	@lua lib/luacc/bin/luacc.lua -o $(OUT_DIR)/specification.lua -i src init rule_registry specification
	@echo "Build complete! Output is in the $(OUT_DIR) folder."

clean:
	rm -rf $(OUT_DIR)

.DEFAULT_GOAL := help