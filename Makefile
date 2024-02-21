RED = \033[0;31m
GREEN = \033[0;32m
DEFAULT = \033[0m

VOLUME = /home/jischoi/data
COMPOSE_FILE = ./srcs/docker-compose.yml

CERTS_DIR = ./srcs/requirements/nginx/tools/certs/
CERTS_KEY = $(CERTS_DIR)/jischoi.42.fr.key
CERTS_CERT = $(CERTS_DIR)/jischoi.42.fr.crt

all: env create-dirs generate-certs
	@echo "$(GREEN)docker compose build$(DEFAULT)"
	docker-compose -f $(COMPOSE_FILE) up --build -d

clean:
	@echo "$(RED)docker compose down$(DEFAULT)"
	docker-compose -f $(COMPOSE_FILE) down

fclean: env clean
	@sudo rm -rf $(VOLUME)
	@docker system prune --all --force --volumes
	@docker network prune --force

re: fclean all

env:
	@if [ -f ./srcs/.env ]; then \
		echo ".env file already exists."; \
	else \
		echo ".env file does not exist. Copying from ~/.env..."; \
		cp ~/.env ./srcs/.env; \
		echo "Copied .env file from ~/.env to ./srcs/.env."; \
	fi
# env:
# 	@test -f ./srcs/.env || cp ~/.env ./srcs/.env

create-dirs:
	@mkdir -p $(VOLUME)
	@mkdir -p $(VOLUME)/mariadb
	@mkdir -p $(VOLUME)/wordpress

generate-certs:
	@mkdir -p $(CERTS_DIR)
	@if [ -f $(CERTS_KEY) ] && [ -f $(CERTS_CERT) ]; then \
		echo "NGINX: SSL certificates already exist."; \
	else \
		echo "Generating SSL certificates..."; \
		openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout "$(CERTS_KEY)" -out "$(CERTS_CERT)" -subj "/C=FR/ST=France/L=Paris/O=42Paris/OU=Bess/CN=jischoi.42.fr"; \
		echo "SSL certificates generated successfully."; \
	fi

create-network:
	@docker network create intra

.PHONY: all clean fclean re env create-dirs generate-certs
