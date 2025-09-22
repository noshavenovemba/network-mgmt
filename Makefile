build:
	docker build -t ghcr.io/noshavenovemba/network-mgmt:dev-latest .

run:
	docker run --rm -it ghcr.io/noshavenovemba/network-mgmt:dev-latest

lint:
	shellcheck backup.sh entrypoint.sh || true
	helm lint ./helmfile.yaml || true

deploy-dev:
	helmfile --environment dev sync

deploy-prod:
	helmfile --environment prod sync

