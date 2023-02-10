
.PHONY: build
build:
	docker build -t grpc-codegen .
	docker build -t grpc-envoy ./envoy

load:
	kind load docker-image grpc-codegen
	kind load docker-image grpc-envoy

apply:
	kubectl apply -f k8s-deploy.yaml
 
start: build load apply

remove:
	kubectl delete -f k8s-deploy.yaml

push:
	docker tag grpc-codegen:latest gcr.io/lab-devops-372913/grpc-codegen:latest
	docker tag grpc-envoy:latest gcr.io/lab-devops-372913/grpc-envoy:latest
	docker push gcr.io/lab-devops-372913/grpc-codegen:latest
	docker push gcr.io/lab-devops-372913/grpc-envoy:latest