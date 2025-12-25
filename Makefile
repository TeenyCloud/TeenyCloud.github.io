# Let's use goold old Makefile
#
.PHONY: help build serve serve-drafts shell clean imgmin update

help:
	@echo "Development commands (all run in Docker container):"
	@echo "  'make build'         - build the Docker image with tools (first time only)"
	@echo "  'make serve'         - build and serve the website in container"
	@echo "  'make serve-drafts'  - serve the website with drafts in container"
	@echo "  'make shell'         - open a shell in the container"
	@echo "  'make imgmin'        - minimize image size (runs in container)"
	@echo "  'make update'        - update gem dependencies"
	@echo "  'make clean'         - remove container and volumes"

build:
	@echo "Building Docker image..."
	docker-compose build

update:
	@echo "Updating gem dependencies..."
	docker-compose run --rm jekyll bundle update

serve:
	@echo "Starting Jekyll server in container..."
	@echo "Site will be available at http://localhost:4000"
	docker-compose up

serve-drafts:
	@echo "Starting Jekyll server with drafts in container..."
	@echo "Site will be available at http://localhost:4000"
	docker-compose run --rm --service-ports jekyll jekyll serve --host 0.0.0.0 --livereload --incremental --watch --drafts

shell:
	@echo "Opening shell in Jekyll container..."
	docker-compose run --rm jekyll /bin/bash

imgmin:
	@echo "Minimizing images in container..."
	@docker-compose run --rm jekyll sh -c "jpegoptim ./assets/images/*.jpg 2>/dev/null || true"
	@docker-compose run --rm jekyll sh -c "optipng ./assets/images/*.png 2>/dev/null || true"
	@echo "Done!"

clean:
	@echo "Removing Docker containers and volumes..."
	docker-compose down -v
