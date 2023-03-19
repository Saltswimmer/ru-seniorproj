export PATH := $(PATH):/usr/local/go/bin

# Pulled from https://gist.github.com/thomaspoignant/5b72d579bd5f311904d973652180c705

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

.PHONY: all test build run

all: help

## Build:
build: ## Build the server
	mkdir -p out/bin
	go build -mod vendor -o out/bin/harbour-api cmd/main.go

## Database:
db.update: ## Update database
	docker-compose up migrate

## Docker:
d.up: ## Start docker compose
	docker-compose up -d
d.down: ## Stop docker container
	docker-compose down

## Lint:
lint: lint-go ## Run all available linters

lint-go: ## Use golintci-lint on your project
	docker run --rm -v $(shell pwd):/app -w /app golangci/golangci-lint:latest-alpine golangci-lint run --deadline=65s

## api:
run: build db.update ## Starts database and builds and runs the server
	./out/bin/harbour-api

test: ## running unit tests
	go test -test.v ./...

## Help:
help: ## Show this help.
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)
