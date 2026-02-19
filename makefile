#!/usr/bin/make

.PHONY: help start serve build deploy publish

help: ## Show this help
	@printf "Usage:\033[36m make [target]\033[0m\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

start: serve

serve: ## Start development server (same as 'start')
	yarn start

build: ## Build the project
	yarn build

deploy: publish

publish: ## Deploy the project (same as 'deploy')
	bash script.sh
