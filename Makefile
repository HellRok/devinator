.PHONY: setup_hooks pretty build clean deploy
clean:
	rm *.gem

build:
	gem build

deploy: clean build
	gem push devinator-*.gem

setup_hooks:
	git config core.hooksPath ./.git-hooks

pretty:
	bin/formatting-fix
