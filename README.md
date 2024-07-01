# Description
A cloud landing zone is a standardized architecture and set of processes for deploying and managing cloud infrastructure. It provides a clear and consistent framework for deploying new workloads to the cloud, enabling organizations to take advantage of the benefits of cloud computing while minimizing the risks and complexities. Typically, a cloud landing zone includes a set of core services, such as identity and access management, networking, and security, that are designed to support the deployment of cloud-based workloads. It also includes processes for monitoring, managing, and scaling those workloads over time. By using a cloud landing zone, organizations can accelerate their adoption of the cloud and better manage their cloud infrastructure.

# Usage

## Bootstrap
TODO

## Core Accounts
* [root](https://000000000001.signin.aws.amazon.com/console) Ilia_Zlobin@org.com
* [identity/000000000002](https://signin.aws.amazon.com/switchrole?account=000000000002&roleName=OrganizationAccountAccessRole&displayName=identity)
* [dns/000000000003](https://signin.aws.amazon.com/switchrole?account=000000000003&roleName=OrganizationAccountAccessRole&displayName=dns)
* [audit/000000000004](https://signin.aws.amazon.com/switchrole?account=000000000004&roleName=OrganizationAccountAccessRole&displayName=audit)

```sh
cd ~/cloudposse/org
# make all
# unset GEODESIC_LOCALHOST
export GEODESIC_LOCALHOST=/root
make run
export HOME=/root
cd ~
. ~/.bashrc-geodesic

sudo apt-get install -y xclip

atmos version
terraform version
aws --version

cd ~/cloudposse/org

unset ATMOS_BASE_PATH
unset ATMOS_CLI_CONFIG_PATH
export ATMOS_BASE_PATH=~/cloudposse/org/
export ATMOS_CLI_CONFIG_PATH=~/cloudposse/org/
export ATMOS_LOGS_VERBOSE=true
unset ATMOS_LOGS_VERBOSE

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
export AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials
export AWS_PROFILE=org-landing-zones
export AWS_DEFAULT_REGION=us-east-1
aws sts get-caller-identity
# aws s3api list-objects-v2 --bucket eplz-gbl-root-tfstate --max-items 1

export ATMOS_COMPONENTS_TERRAFORM_AUTO_GENERATE_BACKEND_FILE=false
unset ATMOS_COMPONENTS_TERRAFORM_AUTO_GENERATE_BACKEND_FILE
atmos terraform plan tfstate-backend -s eplz-core-gbl-root
atmos terraform apply tfstate-backend -s eplz-core-gbl-root
# atmos terraform destroy tfstate-backend -s eplz-core-gbl-root

atmos terraform plan account -s eplz-core-gbl-root
atmos terraform apply account -s eplz-core-gbl-root
atmos terraform output account -s eplz-core-gbl-root
# atmos terraform destroy account -s eplz-core-gbl-root

atmos terraform plan account-map -s eplz-core-gbl-root
atmos terraform apply account-map -s eplz-core-gbl-root
atmos terraform output account-map -s eplz-core-gbl-root
# atmos terraform destroy account-map -s eplz-core-gbl-root

# aws-teams
atmos terraform plan aws-teams -s eplz-core-gbl-identity
atmos terraform apply aws-teams -s eplz-core-gbl-identity
# atmos terraform destroy aws-teams -s eplz-core-gbl-identity

atmos terraform plan aws-sso -s eplz-core-gbl-identity
atmos terraform apply aws-sso -s eplz-core-gbl-identity
# atmos terraform destroy aws-sso -s eplz-core-gbl-identity

# aws-team-roles
atmos terraform plan aws-team-roles -s eplz-core-gbl-dns
atmos terraform apply aws-team-roles -s eplz-core-gbl-dns
# atmos terraform destroy aws-team-roles -s eplz-core-gbl-dns
atmos terraform state aws-team-roles -s eplz-core-gbl-dns list
atmos terraform state aws-team-roles -s eplz-core-gbl-dns show local_file.account_info
atmos terraform state aws-team-roles -s eplz-core-gbl-dns show "aws_iam_role.default[\"terraform\"]"
# arn:aws:iam::000000000003:role/eplz-core-gbl-dns-terraform
# arn:aws:iam::000000000002:role/eplz-core-gbl-identity-admin

# corp epmweb
atmos terraform plan aws-team-roles -s eplz-epmweb-gbl-prod
atmos terraform apply aws-team-roles -s eplz-epmweb-gbl-prod

# corp epme3s
atmos terraform plan aws-team-roles -s eplz-epme3s-gbl-prod
atmos terraform apply aws-team-roles -s eplz-epme3s-gbl-prod
# atmos terraform status aws-team-roles -s eplz-epme3s-gbl-prod

# audit
atmos terraform plan aws-team-roles -s eplz-core-gbl-audit
atmos terraform apply aws-team-roles -s eplz-core-gbl-audit

# network
atmos terraform plan aws-team-roles -s eplz-core-gbl-network
atmos terraform apply aws-team-roles -s eplz-core-gbl-network
```

## Corp Accounts
* [network/000000000005](https://signin.aws.amazon.com/switchrole?account=000000000005&roleName=OrganizationAccountAccessRole&displayName=network)
* [dns/000000000003](https://signin.aws.amazon.com/switchrole?account=000000000003&roleName=OrganizationAccountAccessRole&displayName=dns)
* [audit/000000000004](https://signin.aws.amazon.com/switchrole?account=000000000004&roleName=OrganizationAccountAccessRole&displayName=audit)
* [epme3s/000000000006](https://signin.aws.amazon.com/switchrole?account=000000000006&roleName=OrganizationAccountAccessRole&displayName=epme3s)
* [epmweb/000000000007](https://signin.aws.amazon.com/switchrole?account=000000000007&roleName=OrganizationAccountAccessRole&displayName=epmweb)

```sh
unset AWS_PROFILE
export AWS_ACCESS_KEY_ID="___"
export AWS_SECRET_ACCESS_KEY="___"
export AWS_SESSION_TOKEN="___"
aws sts get-caller-identity
# aws sts assume-role --role-arn "arn:aws:iam::000000000002:role/eplz-core-gbl-identity-admin" --role-session-name AWSCLI-Session
ADMIN_ASSUME_ROLE=$(aws sts assume-role --role-arn "arn:aws:iam::000000000002:role/eplz-core-gbl-identity-admin" --role-session-name AWSCLI-Session); echo $ADMIN_ASSUME_ROLE
export AWS_ACCESS_KEY_ID=$(echo $ADMIN_ASSUME_ROLE | jq -r '.Credentials.AccessKeyId'); echo $AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$(echo $ADMIN_ASSUME_ROLE | jq -r '.Credentials.SecretAccessKey'); echo $AWS_SECRET_ACCESS_KEY
export AWS_SESSION_TOKEN=$(echo $ADMIN_ASSUME_ROLE | jq -r '.Credentials.SessionToken'); echo $AWS_SESSION_TOKEN
aws sts get-caller-identity

aws sts assume-role --role-arn "arn:aws:iam::000000000003:role/eplz-core-gbl-dns-terraform" --role-session-name AWSCLI-Session
# TERRAFORM_DNS_ASSUME_ROLE=$(aws sts assume-role --role-arn "arn:aws:iam::000000000003:role/eplz-core-gbl-dns-terraform" --role-session-name AWSCLI-Session); echo $TERRAFORM_DNS_ASSUME_ROLE
# export AWS_ACCESS_KEY_ID=$(echo $TERRAFORM_DNS_ASSUME_ROLE | jq -r '.Credentials.AccessKeyId'); echo $AWS_ACCESS_KEY_ID
# export AWS_SECRET_ACCESS_KEY=$(echo $TERRAFORM_DNS_ASSUME_ROLE | jq -r '.Credentials.SecretAccessKey'); echo $AWS_SECRET_ACCESS_KEY
# export AWS_SESSION_TOKEN=$(echo $TERRAFORM_DNS_ASSUME_ROLE | jq -r '.Credentials.SessionToken'); echo $AWS_SESSION_TOKEN
# aws sts get-caller-identity

aws sts assume-role --role-arn "arn:aws:iam::000000000001:role/eplz-core-gbl-root-terraform" --role-session-name AWSCLI-Session
# TERRAFORM_CORE_ASSUME_ROLE=$(aws sts assume-role --role-arn "arn:aws:iam::000000000001:role/eplz-core-gbl-root-terraform" --role-session-name AWSCLI-Session); echo $TERRAFORM_CORE_ASSUME_ROLE
# export AWS_ACCESS_KEY_ID=$(echo $TERRAFORM_CORE_ASSUME_ROLE | jq -r '.Credentials.AccessKeyId'); echo $AWS_ACCESS_KEY_ID
# export AWS_SECRET_ACCESS_KEY=$(echo $TERRAFORM_CORE_ASSUME_ROLE | jq -r '.Credentials.SecretAccessKey'); echo $AWS_SECRET_ACCESS_KEY
# export AWS_SESSION_TOKEN=$(echo $TERRAFORM_CORE_ASSUME_ROLE | jq -r '.Credentials.SessionToken'); echo $AWS_SESSION_TOKEN
# aws sts get-caller-identity
# aws s3api list-objects-v2 --bucket eplz-core-gbl-root-tfstate --max-items 1
# aws dynamodb get-item \
#     --table-name eplz-core-gbl-root-tfstate-lock \
#     --key '{"LockID": {"S": "eplz-core-gbl-root-tfstate/tfstate-backend/eplz-core-gbl-root/terraform.tfstate-md5"}}'

aws sts assume-role --role-arn "arn:aws:iam::000000000007:role/eplz-epmweb-gbl-prod-terraform" --role-session-name AWSCLI-Session
aws sts assume-role --role-arn "arn:aws:iam::000000000006:role/eplz-epme3s-gbl-prod-terraform" --role-session-name AWSCLI-Session

# core dns
atmos terraform plan dns-primary -s eplz-core-gbl-dns
atmos terraform apply dns-primary -s eplz-core-gbl-dns

# audit
atmos terraform plan vpc-flow-logs-bucket -s eplz-core-gbl-audit
atmos terraform apply vpc-flow-logs-bucket -s eplz-core-gbl-audit

# network
atmos terraform plan cloud-wan -s eplz-core-gbl-network
atmos terraform apply cloud-wan -s eplz-core-gbl-network
# atmos terraform destroy cloud-wan -s eplz-core-gbl-network # manual removal

atmos terraform plan vpc -s eplz-core-gbl-network
atmos terraform apply vpc -s eplz-core-gbl-network
# atmos terraform destroy vpc -s eplz-core-gbl-network

# corp epme3s
atmos terraform plan dns-delegated -s eplz-epme3s-gbl-prod
atmos terraform apply dns-delegated -s eplz-epme3s-gbl-prod

atmos terraform plan vpc -s eplz-epme3s-ue1-prod
atmos terraform apply vpc -s eplz-epme3s-ue1-prod
# atmos terraform force-unlock vpc -s eplz-epme3s-ue1-prod -force f0131563-efde-bb24-e281-3bb855c17883
# atmos terraform state vpc -s eplz-epme3s-ue1-prod list
# atmos terraform state aws-team-roles -s eplz-core-gbl-dns show local_file.account_info
# atmos terraform state aws-team-roles -s eplz-core-gbl-dns show "aws_iam_role.default[\"terraform\"]"
# atmos terraform destroy vpc -s eplz-epme3s-ue1-prod

# corp epmweb
atmos terraform plan dns-delegated -s eplz-epmweb-gbl-prod
atmos terraform apply dns-delegated -s eplz-epmweb-gbl-prod

atmos terraform plan vpc -s eplz-epmweb-ue1-prod
atmos terraform apply vpc -s eplz-epmweb-ue1-prod
# atmos terraform force-unlock vpc -s eplz-epmweb-ue1-prod -force f0131563-efde-bb24-e281-3bb855c17883
# atmos terraform state vpc -s eplz-epmweb-ue1-prod list
# atmos terraform state aws-team-roles -s eplz-core-gbl-dns show local_file.account_info
# atmos terraform state aws-team-roles -s eplz-core-gbl-dns show "aws_iam_role.default[\"terraform\"]"
# atmos terraform destroy vpc -s eplz-epmweb-ue1-prod
```
