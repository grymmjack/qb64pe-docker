.PHONY: help build test clean run shell

# Variables
IMAGE_NAME := qb64pe
IMAGE_TAG := latest
QB64PE_VERSION := v4.3.0
WORKSPACE := ./workspace

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build the Docker image
	docker build --build-arg QB64PE_VERSION=$(QB64PE_VERSION) -t $(IMAGE_NAME):$(IMAGE_TAG) .

build-no-cache: ## Build the Docker image without cache
	docker build --no-cache --build-arg QB64PE_VERSION=$(QB64PE_VERSION) -t $(IMAGE_NAME):$(IMAGE_TAG) .

test: build ## Build and test with hello.bas
	@echo "Building Docker image..."
	@echo "Testing compilation..."
	docker run --rm -v "$(PWD)/$(WORKSPACE):/workspace" $(IMAGE_NAME):$(IMAGE_TAG) -x -w hello.bas -o hello
	@echo "Testing successful! Executable created:"
	@ls -lh $(WORKSPACE)/hello

compile: ## Compile a QB64 file (usage: make compile FILE=program.bas OUTPUT=program)
	@if [ -z "$(FILE)" ]; then \
		echo "Error: FILE not specified. Usage: make compile FILE=program.bas OUTPUT=program"; \
		exit 1; \
	fi
	@OUTPUT_NAME=$${OUTPUT:-$$(basename $(FILE) .bas)}; \
	docker run --rm -v "$(PWD)/$$(dirname $(FILE)):/workspace" $(IMAGE_NAME):$(IMAGE_TAG) -x -w $$(basename $(FILE)) -o $$OUTPUT_NAME

run: ## Run a compiled program (usage: make run PROGRAM=hello)
	@if [ -z "$(PROGRAM)" ]; then \
		echo "Error: PROGRAM not specified. Usage: make run PROGRAM=hello"; \
		exit 1; \
	fi
	@$(WORKSPACE)/$(PROGRAM)

shell: ## Open a shell in the Docker container
	docker run --rm -it -v "$(PWD)/$(WORKSPACE):/workspace" --entrypoint /bin/bash $(IMAGE_NAME):$(IMAGE_TAG)

clean: ## Clean compiled executables
	rm -f $(WORKSPACE)/hello
	@echo "Cleaned workspace"

clean-docker: ## Remove Docker image
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG) || true

clean-all: clean clean-docker ## Clean everything

compose-build: ## Build using docker-compose
	docker compose build

compose-run: ## Run using docker-compose (usage: make compose-run CMD="-x -w hello.bas")
	docker compose run --rm qb64pe $(CMD)

push: ## Push image to registry (requires login)
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) ghcr.io/grymmjack/qb64pe-docker:$(IMAGE_TAG)
	docker push ghcr.io/grymmjack/qb64pe-docker:$(IMAGE_TAG)

version: ## Show QB64PE version
	docker run --rm $(IMAGE_NAME):$(IMAGE_TAG) --version 2>&1 || echo "Version info not available via --version"

info: ## Show image information
	@echo "Image: $(IMAGE_NAME):$(IMAGE_TAG)"
	@echo "QB64PE Version: $(QB64PE_VERSION)"
	@docker images $(IMAGE_NAME):$(IMAGE_TAG) --format "Size: {{.Size}}"
	@docker images $(IMAGE_NAME):$(IMAGE_TAG) --format "Created: {{.CreatedSince}}"
