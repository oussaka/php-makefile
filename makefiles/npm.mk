WRAPPER_EXEC_USER ?=
NPM_BIN ?= npm

##
## NPM actions
## -----------
##

watch: node_modules                                                             ## Watch the assets and build their development version on change
	$(EXEC) yarn watch

assets: node_modules                                                            ## Build the development version of the assets
	$(EXEC) yarn build-dev

assets-prod: node_modules                                                       ## Build the production version of the assets
	$(EXEC) yarn build-prod

assets-amp: node_modules                                                        ## Build the production version of the AMP CSS
	$(EXEC) yarn build-amp

assets-apps: node_modules                                                       ## Build the production version of the React apps
	$(EXEC) yarn build-apps

node_modules: yarn.lock
	$(EXEC) yarn install

yarn.lock: package.json
	@echo yarn.lock is not up to date.

web/built: front node_modules
	$(EXEC) yarn build-dev

npm-install: ## run npm install
npm-install:
	@$(WRAPPER_EXEC_USER) $(NPM_BIN) install --no-bin-links

.PHONY: npm-install
