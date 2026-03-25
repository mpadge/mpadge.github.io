#!/usr/bin/make

.PHONY: help start serve build deploy publish

help: ## Show this help
	@printf "Usage:\033[36m make [target]\033[0m\n"
	@grep -E '^[a-zA-Z_%_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

start: serve

serve: ## Start development server (same as 'start')
	yarn start

install: ## Install everything to run/build
	yarn install

code: ## Update the 'code' section from current r-univ pkgs list
	Rscript 'tools/code-update.R'

blog%: ## Render a blog post (usage: make blog001)
	cd src/pages/blog && Rscript -e 'source("make_entry.R"); blog_render("blog$*")'

build: ## Build the project
	yarn build

test: ## Run tests
	yarn test

deploy: publish

publish: ## Deploy the project (same as 'deploy')
	bash tools/deploy-script.sh
