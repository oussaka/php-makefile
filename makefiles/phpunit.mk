PHPUNIT ?=$(BIN)/simple-phpunit

ifeq ("$(wildcard $(PHPUNIT))","")
	PHPUNIT ?= $(BIN)/phpunit
endif

##
## Makefile phpunit
## -------------
##

ifdef PHPUNIT_CONFIG_FILE
	PHPUNIT_FLAGS += -c "$(PHPUNIT_CONFIG_FILE)"
endif

phpunit.xml:
	$(PHPUNIT) --generate-configuration

phpunit: $(VENDOR_DIR) 															## Running a test suite by PHPUnit
	$(PHPUNIT) $(PHPUNIT_FLAGS)

.PHONY: phpunit