SHELL = /bin/bash

YELLOW=$(shell tput setaf 3)
RESET=$(shell tput sgr0)

.PHONY: help #	Shows the help menu
help:
	@grep '^.PHONY: .* #' $(MAKEFILE_LIST) | sed 's/.*\.PHONY: \(.*\) #\(.*\)/$(YELLOW)make \1$(RESET) \2/' | expand -t40 | sort -u

.DEFAULT_GOAL := build

.PHONY: build #	Build docker app image
build:
	docker build . \
	--tag star_wars/backend:latest \
	--build-arg MIX_ENV=prod

.PHONY: fetch #	Runs the script inside container
fetch:
	docker run --rm -it -v $(PWD):/opt/app star_wars/backend:latest mix fetch