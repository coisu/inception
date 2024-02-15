RED = \033[0;31m
GREEN = \033[0;32m
DEFAULT = \033[0m

VOLUME = /home/jichoi/data
COMPOSE_FILE = ./srcs/docker-compose.yml

all:
	@mkdir -p $(VOLUME)
	@mkdir -p $(VOLUME)/mariadb
	@mkdir -p $(VOLUME)/wordpress
	@echo "$(GREEN)docker compose build$(DEFAULT)"
	docker-compose -f $(COMPOSE_FILE) up --build -d

clean:
	@echo "$(RED)docker compose down$(DEFAULT)"
	docker-compose -f $(COMPOSE_FILE) down

fclean:
	@sudo rm -rf $(VOLUME)/db $(VOLUME)/wp
	docker-compose -f $(COMPOSE_FILE) down --rmi all
	docker volume rm $$(docker volme ls -f dangling=true -q)
	@rm -rf ./jischoi

re:
	$(make) fclean
	$(make) all

.PHONY: all clean fclean re