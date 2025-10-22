.PHONY: setup_hooks pretty 
setup_hooks:
	git config core.hooksPath ./.git-hooks

pretty:
	bin/formatting-fix
