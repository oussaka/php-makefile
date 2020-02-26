
##
## Database
##---------------------------------------------------------------------------
##

wait-for-db:
	$(EXEC) php -r "set_time_limit(60);for(;;){if(@fsockopen('db',3306)){break;}echo \"Waiting for MySQL\n\";sleep(1);}"

db: vendor wait-for-db                                                          ## Reset the database and load fixtures
	$(CONSOLE) doctrine:database:drop --force --if-exists
	$(CONSOLE) doctrine:database:create --if-not-exists
	$(CONSOLE) doctrine:database:import -n -- dump/dump-2019.sql
	$(CONSOLE) doctrine:migrations:migrate -n
	$(CONSOLE) doctrine:fixtures:load -n

db-diff: vendor wait-for-db                                                     ## Generate a migration by comparing your current database to your mapping information
	$(CONSOLE) doctrine:migration:diff --formatted

db-diff-dump: vendor wait-for-db                                                ## Generate a migration by comparing your current database to your mapping information and display it in console
	$(CONSOLE) doctrine:schema:update --dump-sql

db-migrate: vendor wait-for-db                                                  ## Migrate database schema to the latest available version
	$(CONSOLE) doctrine:migration:migrate -n

db-rollback: vendor wait-for-db                                                 ## Rollback the latest executed migration
	$(CONSOLE) doctrine:migration:migrate prev -n

db-load: vendor wait-for-db                                                     ## Reset the database fixtures
	$(CONSOLE) doctrine:fixtures:load -n

db-validate: vendor wait-for-db                                                 ## Check the ORM mapping
	$(CONSOLE) doctrine:schema:validate
