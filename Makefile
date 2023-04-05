include .env

.PHONY: setup deploy
setup deploy:
	make destroy
	@echo "🚀 Deploying local environment from scratch"
	@docker-compose up -d --remove-orphans
	@echo "⏱ Waiting for database service to be ready"
	@sleep 5
	@echo "📦 Installing Drush and dependencies"
	@docker-compose exec backend composer require drush/drush
	@echo "💧 Installing Drupal"
	@docker-compose exec backend vendor/bin/drush si -y --db-url=mysql://$(DB_USER):$(DB_PASSWORD)@db:3306/$(DB_NAME) --account-name=$(ACCOUNT_NAME) --account-pass=$(ACCOUNT_PASSWORD) --site-name=$(SITE_NAME) --site-mail=$(SITE_MAIL) --account-mail=$(SITE_MAIL)
	echo "drush si -y --db-url=mysql://$(DB_USER):$(DB_PASSWORD)@db:3306/$(DB_NAME) --account-name=$(ACCOUNT_NAME) --account-pass=$(ACCOUNT_PASSWORD) --site-name=$(SITE_NAME) --site-mail=$(SITE_MAIL) --account-mail=$(SITE_MAIL)"
	@echo "🔧 Fix permissions"
	@docker-compose exec backend chmod -R 777 web/sites/default/files
	@echo "🧹 Clearing the cache"
	@docker-compose exec backend vendor/bin/drush cr

.PHONY: stop
stop:
	@echo "🛑 Stopping infrastructure"
	docker-compose stop

.PHONY: varnishlog
varnishlog:
	@echo "📜 Varnish log"
	# https://stackoverflow.com/a/6273809/104380
	docker-compose exec varnish varnishlog $(OPTIONS) "$(filter-out $@,$(MAKECMDGOALS))"

.PHONY: vcl varnish-vcl
vcl varnish-vcl:
	@echo "🏭 Building varnish and applying new configuration"
	docker-compose up -d varnish

.PHONY: destroy
destroy:
	@echo "🔥 Destroying local environment"
	docker-compose down -v

%:
	@: