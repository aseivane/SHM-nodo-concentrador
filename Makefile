ifeq ($(OS),Windows_NT)
	# Windows part
	example_cmd:=set
else
	# UNIX (Linux/FreeBSD/MacOS) part
	example_cmd:=export
endif

clean : clean-docker-images
clean-docker-images : clean-docker-containers 


.PHONY: prod
prod:
	# docker network create my_network
	docker-compose -f docker-compose.prod.yml build #Build prod 
	# Up prod in detached mode
	docker-compose -f docker-compose.prod.yml up -d


.PHONY: dev
dev:
	# docker network create my_network
	docker-compose -f docker-compose.dev.yml build #Build dev 
	# Up prod in detached mode
	docker-compose -f docker-compose.dev.yml up -d

.PHONY: clean
clean-docker-images : clean-docker-volumes
	echo "All clean"

.PHONY: clean-docker-volumes
clean-docker-volumes : clean-docker-containers 
	docker volume rm $$(docker volume ls -q) 2> /dev/null

.PHONY: clean-docker-images
clean-docker-images : clean-docker-containers 
	docker rmi $$(docker images --all -q) 2> /dev/null


.PHONY: clean-docker-containers
clean-docker-containers :
	docker rm -f -v $$(docker ps -q) 2> /dev/null