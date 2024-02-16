RED = \033[0;31m
GREEN = \033[0;32m
DEFAULT = \033[0m

VOLUME = /home/jischoi/data
COMPOSE_FILE = ./srcs/docker-compose.yml

all: env
	@mkdir -p $(VOLUME)
	@mkdir -p $(VOLUME)/mariadb
	@mkdir -p $(VOLUME)/wordpress
	@echo "$(GREEN)docker compose build$(DEFAULT)"
	docker-compose -f $(COMPOSE_FILE) up --build -d

clean:
	@echo "$(RED)docker compose down$(DEFAULT)"
	docker-compose -f $(COMPOSE_FILE) down

fclean: env
	@sudo rm -rf $(VOLUME)/db $(VOLUME)/wp
	@docker system prune --all --force --volumes
	@docker network prune --force

re:
	$(make) fclean
	$(make) all

env:
	@test -f ./srcs/.env || cp ~/.env ./srcs/.env

.PHONY: all clean fclean re
