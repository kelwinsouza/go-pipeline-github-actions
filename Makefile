lint:
	docker run --rm -it -v $(CURDIR):/app -w /app golangci/golangci-lint \
	golangci-lint run controllers/ database/ models/ routes/

test:
	docker compose exec app-dev go test ./...

start:
	docker compose up -d

ci: start lint test

cd:
	docker run --rm -it -v $(CURDIR):/app -w /app golang:1.22-alpine \
	go build -o main main.go
	scp -i ~/.ssh/curso-cd-aws.pem templates ec2-user@ec2-54-160-106-151.compute-1.amazonaws.com:/home/ec2-user
	scp -i ~/.ssh/curso-cd-aws.pem assets ec2-user@ec2-54-160-106-151.compute-1.amazonaws.com:/home/ec2-user
	scp -i ~/.ssh/curso-cd-aws.pem main ec2-user@ec2-54-160-106-151.compute-1.amazonaws.com:/home/ec2-user
