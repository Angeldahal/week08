# Task 9.3C continuous deployment

The pipeline is split into four workflows:

1. `01-ci.yml` tests pull requests and main-branch pushes, then builds six SHA-tagged images on main.
2. `02-deploy-staging.yml` runs after successful main-branch CI and deploys the tested images.
3. `03-staging-test.yml` runs after successful staging deployment and checks the image SHA and served frontend.
4. `04-deploy-production.yml` automatically deploys after successful staging tests.

Each deployment workflow uses `workflow_run` with a success condition. CI records the tested commit in a `release-metadata` artifact; staging and staging tests forward that same artifact. Production therefore checks out and deploys the original tested commit, even if main changes while the chain runs. Pull request runs cannot trigger deployments.

## Local-only default

All Azure jobs require the repository variable `AZURE_DEPLOYMENT_ENABLED` to equal `true`. Leave it unset or false for local-only work. Pull requests never run Azure jobs. Set the variable to true only when the Azure resources and deployment identity are configured.

## Configuration

The frontend test/build job uses the same five relative API paths as its Dockerfile. Backend tests discard checked-out `.env` and `.env.test` files in the ephemeral CI checkout and use the job's PostgreSQL settings and empty Azure storage settings. Backend `.dockerignore` files prevent local environment configuration from being copied into images.

For cloud deployment, the build job requires repository secrets/variables: `AZURE_CREDENTIALS`, `ACR_NAME` and `ACR_LOGIN_SERVER`. Staging and production require `AKS_RESOURCE_GROUP`, `AKS_CLUSTER_NAME`, `ACR_LOGIN_SERVER`, and `AZURE_CREDENTIALS`, `POSTGRES_USER`, `POSTGRES_PASSWORD`, `JWT_SECRET_KEY`, `DEFAULT_ADMIN_USERNAME`, `DEFAULT_ADMIN_EMAIL`, `DEFAULT_ADMIN_PASSWORD`, `STORAGE_ACCOUNT_NAME`. The deployment retrieves the current storage connection string using its scoped Azure identity and masks it in logs; the connection string does not need a separate GitHub secret. Check Azure permissions, ACR attachment to AKS, and environment protection rules before enabling the pipeline. Required production approvals pause automatic promotion until approved.

## Release evidence

The login and authenticated header display `KoalaTech University - CD Release 9.3C`. The smoke checks verify the frontend and the served release asset; they do not replace a browser screenshot showing the visible update or full application end-to-end tests.

Capture the pull request and merge SHA, successful Actions stages, production browser result and Azure cleanup evidence for the final submission. The release can be deployed after merging the pull request to main. Save live deployment evidence before performing Azure cleanup.
