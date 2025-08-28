# Atmos Landing Zones

## Project Overview

This repository implements a robust, production-grade **Cloud Landing Zone** using [Atmos](https://github.com/cloudposse/atmos), [Terraform](https://www.terraform.io/), [Helmfile](https://github.com/helmfile/helmfile), and supporting build harnesses. It provides a secure, scalable, and automated foundation for multi-account, multi-region AWS environments, enabling rapid onboarding, compliance, and operational excellence for cloud workloads.

### Core Benefits
- Automated provisioning of AWS accounts, IAM roles, networking, security, and audit controls
- Modular, reusable infrastructure as code (IaC) patterns
- Centralized configuration and policy enforcement
- Extensible for business units, environments, and future cloud providers

---

## Architecture Overview

### Core Accounts & IAM Roles
- **Identity**: Centralized user and role management (SSO, SAML, teams)
- **Networking**: VPCs, Cloud WAN, DNS zones, flow logs
- **Security**: Guardrails, IAM roles, audit logging, encryption
- **Audit**: Centralized logging, compliance, and monitoring

IAM roles are provisioned and delegated using the `aws-teams`, `aws-team-roles`, `aws-sso`, and `aws-saml` Terraform components. Role assumption and permission sets are managed via AWS SSO and SAML integrations.

### Terraform & Helmfile Structure
- **Terraform**: Modular components for accounts, networking, DNS, security, and more, organized under `components/terraform/`
- **Helmfile**: Kubernetes workload orchestration under `components/helmfile/`, with example charts (e.g., echo-server)

### Atmos Configuration Model
- Centralized configuration in `atmos.yaml` and stack YAMLs under `stacks/`
- Supports environment, region, and account overlays
- Parameterization via variables, environment variables, and shared credentials

### Build Harness Usage
- CI/CD automation, wrapper scripts, and Docker-based workflows via `build-harness/` and `Makefile`
- Geodesic shell for reproducible developer environments

### Multi-Account / Multi-Region
- Stacks and components support deployment across multiple AWS accounts and regions
- State isolation and remote state management via S3/DynamoDB backends

---

## Repository Layout

```text
components/         # Terraform modules & Helmfile charts
  terraform/        # Core infra modules (accounts, vpc, dns, security, etc.)
  helmfile/         # Kubernetes charts & orchestration
stacks/             # Org, corp, prod, example stack definitions
build-harness/      # CI/CD helpers, automation scripts
terraform-vendor/   # Vendor modules (Cloud Posse, etc.)
atmos.yaml          # Atmos configuration
Dockerfile          # Geodesic shell & Atmos/Terraform/Helmfile setup
Makefile            # Build harness entrypoint
```

---

## Bootstrap Instructions

1. **Install Prerequisites**
	- Docker, AWS CLI, Terraform, Atmos, Helmfile
2. **Initialize Geodesic Shell**
	```sh
	make run
	. ~/.bashrc-geodesic
	atmos version
	terraform version
	aws --version
	```
3. **Configure AWS Credentials**
	```sh
	export AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials
	export AWS_PROFILE=org-landing-zones
	export AWS_DEFAULT_REGION=us-east-1
	aws sts get-caller-identity
	```
4. **Bootstrap Core Accounts**
	```sh
	atmos terraform apply tfstate-backend -s eplz-core-gbl-root
	atmos terraform apply account -s eplz-core-gbl-root
	atmos terraform apply account-map -s eplz-core-gbl-root
	atmos terraform apply aws-teams -s eplz-core-gbl-identity
	atmos terraform apply aws-sso -s eplz-core-gbl-identity
	atmos terraform apply aws-team-roles -s eplz-core-gbl-dns
	atmos terraform apply aws-team-roles -s eplz-core-gbl-audit
	atmos terraform apply aws-team-roles -s eplz-core-gbl-network
	atmos terraform apply dns-primary -s eplz-core-gbl-dns
	atmos terraform apply vpc-flow-logs-bucket -s eplz-core-gbl-audit
	atmos terraform apply cloud-wan -s eplz-core-gbl-network
	atmos terraform apply vpc -s eplz-core-gbl-network
	```
5. **Assume Roles & Validate**
	```sh
	aws sts assume-role --role-arn "arn:aws:iam::<account_id>:role/<role_name>" --role-session-name AWSCLI-Session
	aws sts get-caller-identity
	```

---

## Usage Guide

### Deploy New Stacks
```sh
atmos terraform plan <component> -s <stack>
atmos terraform apply <component> -s <stack>
```

### Manage Environments
- Stacks are defined for org, corp, prod, dev, etc. in `stacks/`
- Use overlays and variables for environment-specific configuration

### Run Terraform via Atmos
```sh
atmos terraform plan vpc -s eplz-core-gbl-network
atmos terraform apply vpc -s eplz-core-gbl-network
```

### Integrate with AWS CLI & Validate IAM Roles
```sh
aws sts assume-role --role-arn "arn:aws:iam::<account_id>:role/<role_name>" --role-session-name AWSCLI-Session
aws sts get-caller-identity
```

---

## Development Workflow

### Make & Build Harness
- Use `make` targets for common tasks (init, deps, build, run)
- CI/CD helpers in `build-harness/`

### Terraform Plans & Applies
- Use Atmos CLI for all Terraform operations
- State managed via S3/DynamoDB backends

### Helmfile for Kubernetes
- Deploy charts via Helmfile in `components/helmfile/`

### Testing Changes
- Use `stacks-example/` for sandbox and test deployments

---

## Configuration & Parameters

- **atmos.yaml**: Central config for component paths, stack overlays, workflows
- **Environment Variables**: Used for credentials, region, verbosity, etc.
- **.aws/credentials**: Shared AWS credentials file

---

## Security & Compliance

- IAM guardrails, least-privilege roles, and audit logging
- VPC Flow Logs, encrypted S3 buckets, and centralized logging
- Network segmentation and account isolation
- Automated role assumption and permission set management

---

## Extensibility

- Add new Terraform components in `components/terraform/`
- Add new stacks for business units or environments in `stacks/`
- Customize policies, networking, and guardrails via overlays and variables

---

## Roadmap

- Multi-cloud support (Azure, GCP)
- Advanced monitoring and observability
- CI/CD pipeline integration
- Policy-as-code and automated compliance

---

## References

- [Atmos Documentation](https://github.com/cloudposse/atmos)
- [Terraform Documentation](https://www.terraform.io/docs/)
- [Helmfile Documentation](https://github.com/helmfile/helmfile)
- [AWS Landing Zone Best Practices](https://docs.aws.amazon.com/controltower/latest/userguide/landing-zone.html)

---

## License & Credits

This repository is licensed under the [Apache 2.0 License](LICENSE).

Credits: Cloud Posse, AWS, Helmfile, Terraform, and all contributors.
