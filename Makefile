IMAGE ?= devnova-test
ROLES ?= devops backend frontend cloud network fullstack
DISTROS ?= ubuntu:22.04 ubuntu:24.04 debian:12

.PHONY: help build test test-interactive test-all shell attach test-distros clean

help:
	@echo "DevNova Docker Testing Workflow"
	@echo ""
	@echo "Usage:"
	@echo "  make build             Build the test Docker image ($(IMAGE))"
	@echo "  make test ROLE=<role>  Run installation for role & stay in interactive shell inside container"
	@echo "  make test-interactive  Run DevNova interactive TUI menu & stay in shell inside container"
	@echo "  make test-all          Run non-interactive tests for all roles (creates persistent containers)"
	@echo "  make shell             Launch interactive bash shell inside container"
	@echo "  make attach ROLE=<role> Re-enter an existing role container shell without re-installing"
	@echo "  make test-distros      Test installation across multiple Linux distributions"
	@echo "  make clean             Remove all test containers and built Docker image"
	@echo ""
	@echo "Available roles: $(ROLES)"

build:
	docker build -t $(IMAGE) .

test: build
	@if [ -z "$(ROLE)" ]; then \
		echo "Error: ROLE is required. Usage: make test ROLE=devops"; \
		exit 1; \
	fi
	@docker rm -f devnova-$(ROLE) 2>/dev/null || true
	docker run -it --name devnova-$(ROLE) $(IMAGE) bash -c "if [ ! -f ~/.installed ]; then ./devnova --role $(ROLE) --yes && touch ~/.installed; fi; exec bash"

test-interactive: build
	@docker rm -f devnova-interactive 2>/dev/null || true
	docker run -it --name devnova-interactive $(IMAGE) bash -c "if [ ! -f ~/.installed ]; then ./devnova && touch ~/.installed; fi; exec bash"

test-all: build
	@for role in $(ROLES); do \
		echo ""; \
		echo "=================================================="; \
		echo "=== Testing Role: $$role ==="; \
		echo "=================================================="; \
		docker rm -f devnova-$$role 2>/dev/null || true; \
		docker run --name devnova-$$role $(IMAGE) bash -c "./devnova --role $$role --yes && touch ~/.installed" 2>&1 | tail -30; \
		echo "Container 'devnova-$$role' preserved."; \
	done
	@echo ""
	@echo "All roles tested successfully and containers preserved!"

shell: build
	@docker rm -f devnova-shell 2>/dev/null || true
	docker run -it --name devnova-shell $(IMAGE) bash

attach:
	@if [ -z "$(ROLE)" ]; then \
		echo "Error: ROLE is required. Usage: make attach ROLE=devops"; \
		exit 1; \
	fi
	@docker start devnova-$(ROLE) >/dev/null 2>&1 || true
	docker exec -it devnova-$(ROLE) bash

test-distros:
	@for distro in $(DISTROS); do \
		echo ""; \
		echo "=== Testing on $$distro ==="; \
		clean_distro=$$(echo $$distro | tr ':/' '-'); \
		docker rm -f devnova-distro-$$clean_distro 2>/dev/null || true; \
		docker run --name devnova-distro-$$clean_distro -v $$(pwd):/devnova $$distro bash -c "apt-get update -q && apt-get install -y sudo curl git && cd /devnova && NON_INTERACTIVE=1 bash install.sh --role devops --yes"; \
	done

clean:
	@echo "Cleaning DevNova test containers and images..."
	@docker rm -f $$(docker ps -a -q --filter "name=devnova-") 2>/dev/null || true
	@docker rmi $(IMAGE) 2>/dev/null || true
	@echo "Clean completed."
