.PHONY: test build clean help

help:
	@echo "Available targets:"
	@echo "  make test    - Run all unit tests"
	@echo "  make build   - Build the specification library"
	@echo "  make clean   - Remove build artifacts"

test:
	@for file in test/*_tests.lua; do \
		echo "Running $$file..."; \
		lua $$file || exit 1; \
	done
	@echo "All tests passed!"

build:
	./build.sh

clean:
	rm -rf out

.DEFAULT_GOAL := help
