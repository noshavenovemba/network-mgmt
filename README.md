🛠️ Network Management Project

This repository contains a containerized network management tool with CI/CD automation and Kubernetes deployment support.

📂 Project structure
.
├── Dockerfile              # build container image
├── .dockerignore           # ignore unnecessary files in image
├── entrypoint.sh           # entry script inside container
├── backup.sh               # backup utility script
│
├── helmfile.yaml           # defines Kubernetes deployments
├── values-template.yaml    # base config
├── values-dev.yaml         # dev environment values
├── values-staging.yaml     # staging environment values
├── values-prod.yaml        # production environment values
│
├── k8s/
│   └── cronjob-backup.yaml # K8s CronJob for automated backups
│
├── Jenkinsfile             # CI/CD pipeline definition
├── Makefile                # helper commands
└── README.md               # documentation

🚀 Build & Run locally
Build Docker image
docker build -t network-mgmt:local .

Run container
docker run --rm -it network-mgmt:local

Run backup script manually
./backup.sh

⚙️ Helmfile deployment

This project uses Helmfile
 to manage Kubernetes deployments.

Deploy to dev
helmfile -e dev sync

Deploy to staging
helmfile -e staging sync

Deploy to production
helmfile -e prod sync


Each environment uses its own values-*.yaml file.

⏰ Backup CronJob

A Kubernetes CronJob (k8s/cronjob-backup.yaml) runs backup.sh inside a container once per day (02:00 by default).

Deploy it with Helmfile or apply manually:

kubectl apply -f k8s/cronjob-backup.yaml

🔄 CI/CD (Jenkins)

The Jenkinsfile defines a pipeline with these stages:

Checkout – fetch repository source

Lint & Validate – shell scripts & Helm configs

Build Docker image – from Dockerfile

Push image – to container registry (on main branch)

Deploy – run Helmfile sync (on main branch)

Credentials (Docker registry, kubeconfig) are stored in Jenkins and injected during build.

📖 Makefile (optional)

For convenience, you can run:

make build       # build Docker image
make run         # run container
make lint        # lint scripts & helm configs
make deploy-dev  # deploy to dev cluster
make deploy-prod # deploy to production

✅ Next steps

Expand backup.sh logic as needed

Add monitoring/logging configs (optional)

Write automated tests for scripts & configs
