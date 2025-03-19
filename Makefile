CONTAINER_NAME = dnezhkin-db
DATABASE_NAME = hw_db
DATABASE_USER = dnezhkin

up:
	@docker run -d \
      --name ${CONTAINER_NAME} \
      -p 55432:5432 \
      -e POSTGRES_USER=${DATABASE_USER} \
      -e POSTGRES_PASSWORD=wC3DXRWgCM \
      -e POSTGRES_HOST_AUTH_METHOD=trust \
      -e POSTGRES_DB=${DATABASE_NAME} \
      --restart always \
      postgres:17.4

stop:
	@docker stop ${CONTAINER_NAME}

rm:
	@docker rm ${CONTAINER_NAME}

migration_up:
	cat migrations/up.sql | docker exec -i ${CONTAINER_NAME} psql -U ${DATABASE_USER} -d ${DATABASE_NAME}

migration_down:
	cat migrations/down.sql | docker exec -i ${CONTAINER_NAME} psql -U ${DATABASE_USER} -d ${DATABASE_NAME}

do_tasks:
	bash ./solutions/run.sh ${CONTAINER_NAME} ${DATABASE_NAME} ${DATABASE_USER}

sleep:
	@echo "Ждем 10 сек"
	@sleep 10

clear:
	clear

run: up sleep migration_down migration_up clear do_tasks
rerun: stop rm run