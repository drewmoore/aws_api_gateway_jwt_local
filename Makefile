SHELL = /bin/bash
.SILENT:

all: app apply_infra

app:
	- docker container ls | grep ngrok-agent || docker compose up --build --remove-orphans -d
	- cd .. && docker container ls | grep my-app || docker compose up --build --remove-orphans -d

teardown_app:
	- docker compose down -v
	- cd .. && docker compose down -v

apply_infra:
	- until [ -n "$$TF_VAR_local_proxy_base_url" ]; do sleep 1 && export TF_VAR_local_proxy_base_url=$$(curl --silent --show-error --fail http://localhost:9002/tunnel_url); done && cd infra && . ./.env && tfenv use && terraform apply

teardown_infra:
	- until [ -n "$$TF_VAR_local_proxy_base_url" ]; do sleep 1 && export TF_VAR_local_proxy_base_url=$$(curl --silent --show-error --fail http://localhost:9002/tunnel_url); done && cd infra && . ./.env && tfenv use && terraform destroy

jwt:
	- curl http://localhost:9002/jwt
	- echo "   <- Use this value in a header \"Authorization: Bearer TOKEN_VALUE\""
