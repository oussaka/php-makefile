COMPOSER_BIN ?= composer

##
## Composer
##---------------------------------------------------------------------------
##

vendor: composer.lock															## deps update
	$(COMPOSER_BIN) install -n

composer.lock: composer.json
	@echo composer.lock is not up to date.

.PHONY: vendor composer.lock
