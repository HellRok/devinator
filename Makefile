.PHONY: setup_hooks pretty build
build:
	gem build

setup_hooks:
	git config core.hooksPath ./.git-hooks

pretty:
	bin/formatting-fix
