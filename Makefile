ifeq ($(OS),Windows_NT)
	# Windows part
	example_cmd:=set
else
	# UNIX (Linux/FreeBSD/MacOS) part
	example_cmd:=export
endif

clean : clean-docker-images
clean-docker-images : clean-docker-containers 

## make local-prod # runs in production mode with localhost
.PHONY: local-prod
local-prod:
	# docker network create my_network
	docker compose --env-file .nextjs.env.local -f docker-compose.prod.yml build
	# Up prod in detached mode
	docker compose --env-file .nextjs.env.local -f docker-compose.prod.yml up -d

## make prod # runs in production mode
.PHONY: prod
prod:
	# docker network create my_network
	docker compose --env-file .nextjs.env.prod -f docker-compose.prod.yml build #Build prod 
	# Up prod in detached mode
	docker compose --env-file .nextjs.env.prod -f docker-compose.prod.yml up -d

## make dev # runs in dev mode with autoupdate code
.PHONY: dev
dev:
	# docker network create my_network
	docker compose --env-file .nextjs.env.local -f docker-compose.dev.yml build #Build dev 
	# Up prod in detached mode
	docker compose --env-file .nextjs.env.local -f docker-compose.dev.yml up -d

## make clean # cleans all the docker resources
.PHONY: clean
clean-docker-images : clean-docker-volumes
	echo "All clean"

## make clean-docker-volumes # cleans docker volumes
.PHONY: clean-docker-volumes
clean-docker-volumes : clean-docker-containers 
	docker volume rm $$(docker volume ls -q) 2> /dev/null

## make clean-docker-images # cleans docker images
.PHONY: clean-docker-images
clean-docker-images : clean-docker-containers 
	docker rmi $$(docker images --all -q) 2> /dev/null

## make clean-docker-containers # cleans docker containers
.PHONY: clean-docker-containers
clean-docker-containers :
	docker rm -f -v $$(docker ps -q -a) 2> /dev/null

help: Makefile
	@echo
	@echo " Choose a command to run:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s '#' |  sed -e 's/^/ /'
	@echo

.DEFAULT_GOAL := help