# Task 9.3C continuous deployment

The combined `.github/workflows/01-ci.yml` checks pull requests to main. A main-branch push can promote one commit through image builds, staging, smoke checks and production, using job dependencies and the same commit SHA throughout.

## Local-only default

All Azure jobs require the repository variable `AZURE_DEPLOYMENT_ENABLED` to equal `true`. Leave it unset or false for local-only work. Pull requests never run Azure jobs. Set the variable to true only when the Azure resources and deployment identity are configured.

## Configuration

The frontend test/build job uses the same five relative API paths as its Dockerfile. Backend tests discard checked-out `.env` and `.env.test` files in the ephemeral CI checkout and use the job's PostgreSQL settings and empty Azure storage settings. Backend `.dockerignore` files prevent local environment configuration from being copied into images.

For cloud deployment, the build job requires repository secrets/variables: `AZURE_CREDENTIALS`, `ACR_NAME` and `ACR_LOGIN_SERVER`. Staging and production require `AKS_RESOURCE_GROUP`, `AKS_CLUSTER_NAME`, `ACR_LOGIN_SERVER`, and `AZURE_CREDENTIALS`, `POSTGRES_USER`, `POSTGRES_PASSWORD`, `JWT_SECRET_KEY`, `DEFAULT_ADMIN_USERNAME`, `DEFAULT_ADMIN_EMAIL`, `DEFAULT_ADMIN_PASSWORD`, `STORAGE_ACCOUNT_NAME`. The deployment retrieves the current storage connection string using its scoped Azure identity and masks it in logs; the connection string does not need a separate GitHub secret. Check Azure permissions, ACR attachment to AKS, and environment protection rules before enabling the pipeline. Required production approvals pause automatic promotion until approved.

## Release evidence

The login and authenticated header display `KoalaTech University - CD Release 9.3C`. The smoke checks verify the frontend and the served release asset; they do not replace a browser screenshot showing the visible update or full application end-to-end tests.

Capture the pull request and merge SHA, successful Actions stages, production browser result and Azure cleanup evidence for the final submission. The release can be deployed after merging the pull request to main. Save live deployment evidence before performing Azure cleanup.
