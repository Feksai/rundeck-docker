build:
	docker build --tag=rundeck .

run:
	docker run -d --name rundeck -p 4440:4440 -e SERVER_NAME=http://192.168.33.54:4440 rundeck

drop:
	docker stop $(shell docker ps -aq) && docker rm $(shell docker ps -aq)

rename:
	docker tag rundeck:latest rundeck:$(shell cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1) && docker rmi rundeck:latest
