RED = \033[0;31m
GREEN = \033[0;32m
DEFAULT = \033[0m

VOLUME = /home/jischoi/data
COMPOSE_FILE = ./srcs/docker-compose.yml

all: env create-dirs
	@echo "$(GREEN)docker compose build$(DEFAULT)"
	docker-compose -f $(COMPOSE_FILE) up --build -d

clean:
	@echo "$(RED)docker compose down$(DEFAULT)"
	docker-compose -f $(COMPOSE_FILE) down

fclean: env
	# @rm -rf $(VOLUME)
	@docker system prune --all --force --volumes
	@docker network prune --force

re:

	$(make) fclean
	$(make) all

env:
	@if [ -f ./srcs/.env ]; then \
		echo "The .env file exists."; \
	else \
		echo "The .env file does not exist. Copying from ~/.env..."; \
		cp ~/.env ./srcs/.env; \
		echo "Copied .env file from ~/.env to ./srcs/.env."; \
	fi
# env:
# 	@test -f ./srcs/.env || cp ~/.env ./srcs/.env

create-dirs:
	@mkdir -p $(VOLUME)
	@if mkdir -p $(VOLUME)/mariadb; then \
		echo "Successfully created directory $(VOLUME)/mariadb"; \
	else \
		echo "Failed to create directory $(VOLUME)/mariadb"; \
	fi
	@mkdir -p $(VOLUME)/wordpress

create-network:
	@docker network create intra

.PHONY: all clean fclean re
