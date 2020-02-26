
##
## Makefile lint
## -------------
##

lint: ls ly lt lj phpcs                                                         ## Run lint on Twig, YAML, PHP and Javascript files

ls: ly lt                                                                       ## Lint Symfony (Twig and YAML) files

ly:
	$(CONSOLE) lint:yaml config --parse-tags

lt:
	$(CONSOLE) lint:twig templates

lj: node_modules                                                                ## Lint the Javascript to follow the convention
	$(EXEC) yarn lint

ljfix: node_modules                                                             ## Lint and try to fix the Javascript to follow the convention
	$(EXEC) yarn lint -- --fix

phpcs: vendor                                                                   ## Lint PHP code
	$(PHPCSFIXER) fix --diff --dry-run --no-interaction -v

phpcsfix: vendor                                                                ## Lint and fix PHP code to follow the convention
	$(PHPCSFIXER) fix

.PHONY: lint
