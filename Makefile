PORT_MAPPING:=5432:5432
DOCKER_IMAGE:=postgres:12-alpine
DB_URL=postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable

postgres:
		docker run --name postgres12 -p $(PORT_MAPPING) -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d $(DOCKER_IMAGE)

createdb:
		docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
		docker exec -it postgres12 dropdb simple_bank

migrateup:
		migrate -path db/migration -database $(DB_URL) -verbose up

migratedown:
		migrate -path db/migration -database $(DB_URL) -verbose down

sqlc:
		sqlc generate

test:
		go test -v -cover ./...

server:
		go run main.go

.PHONY: postgres createdb dropdb migrateup migratedown sqlc server