.PHONY: run
run:
	docker network create my_network ;
	docker-compose -f docker-compose.yml build #Build prod 
	# Up prod in detached mode
	docker-compose -f docker-compose.yml up -d


.PHONY: clean-docker-images
clean-docker-images:
	sudo docker rmi $(sudo docker images --all -q)

.PHONY: clean-docker
clean-docker-containers:
	sudo docker rm $(sudo docker ps -q)