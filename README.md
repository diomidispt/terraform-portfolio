
# terraform
A consolidated infrastructure repository for scalable, modular, and DRY Terraform infrastructure.

# Scalable, DRY, and Modular Terraform Architecture (Summary)

## Pattern Overview

This repository uses a scalable, modular, and DRY pattern for Terraform. It supports multiple environments, accounts, and regions, while minimizing code duplication.

**Key points:**
- Common code and variables are symlinked into each environment.
- `modules/resources/` are for atomic, reusable building blocks (e.g., VPC, EC2, KMS).
- `modules/solutions/` are for higher-level, opinionated stacks (e.g., RDS, Bastion Host).
- Each environment folder under `envs/` is a self-contained workspace with its own state and backend.
- Use `create_env.sh` to generate new environments quickly and consistently.


## Folder Structure Explained

```
.
├── common/
│   └── accounts/
│       └── <account>/
│           ├── account.tfvars
│           └── region.<region>.tfvars
├── envs/
│   └── <solution>/
│       ├── common/
│       └── <account>-<region>-<solution>-<env>/
│           ├── common.account.auto.tfvars
│           ├── common.main.tf
│           ├── common.provider.tf
│           ├── common.region.auto.tfvars
│           ├── common.variables.tf
│           ├── state.tf
│           └── terraform.tfvars
├── modules/
│   ├── resources/
│   └── solutions/
└── create_env.sh
```

**1. `common/`**
- Stores reusable configuration for all accounts and regions.
- Each account (e.g., `my-account`) has its own folder with:
   - `account.tfvars`: account-wide variables (e.g., account_id, tags).
   - `region.<region>.tfvars`: region-specific variables (e.g., region, AZs).
- These files are symlinked into each environment folder to avoid duplication and ensure consistency.

**2. `envs/`**
- This is where you run `terraform apply` for real deployments.
- Each solution (e.g., `rds`, `vpc`) has:
   - A `common/` folder with shared code for that solution.
   - One or more environment folders named `<account>-<region>-<solution>-<env>` (e.g., `my-account-us-east-1-rds-airflow-DEV`).
- Each environment folder contains:
   - Symlinks to shared code and variables (`common.*.tf`, `common.account.auto.tfvars`, `common.region.auto.tfvars`).
   - `state.tf`: backend config for remote state.
   - `terraform.tfvars`: environment-specific variables.
   - All files needed to run Terraform independently for that environment.
- Environment folders are generated using `create_env.sh` for consistency.

**3. `modules/`**
- **`resources/`**: Atomic, reusable building blocks (e.g., `ec2-instance`, `kms`, `vpc`). Each module encapsulates a single resource or a tightly related set of resources. Use these for composing solutions.
- **`solutions/`**: Higher-level, opinionated modules that combine multiple resources to deliver a complete solution (e.g., `bastion-host`, `rds-instance`, `subnet-router`).

**4. `create_env.sh`**
- Interactive script to generate new environment folders under `envs/`.
- Creates all necessary symlinks and scaffolds required files.
- Handles backend configuration, symlinking, and initial formatting.
- Ensures consistency and reduces manual errors when onboarding new environments.

**How to use:**
1. Run `./create_env.sh` and follow prompts.
2. Edit `terraform.tfvars` in the new environment folder.
3. Run Terraform commands inside that folder.

**Symlinks:**
- Environment folders contain symlinks to shared code and variables, ensuring DRY and consistent deployments.

**Benefits:**
- Easy to scale, maintain, and onboard new engineers.
- No code duplication; updates to shared code are reflected everywhere.
- Each environment is isolated and safe for parallel work.

For more details, see the comments in `create_env.sh` and the rest of this README.


## Initializing the Terraform State Backend

This repo uses a dedicated module to manage the Terraform state backend (S3 bucket and DynamoDB table). Follow the steps below to initialize the state:

1. **Navigate to the folder that applies the module**:
   ```bash
   cd terraform/envs/tf-state-backend-s3/my-account-us-east-1-cicd-tfstate
   ```

2. **Initialize Terraform**:
   Run the following command to initialize the Terraform configuration:
   ```bash
   terraform init
   ```

3. **Validate the configuration**:
   Ensure the configuration is valid:
   ```bash
   terraform validate
   ```

4. **Plan the changes**:
   Generate an execution plan to review the changes:
   ```bash
   terraform plan
   ```

5. **Apply the changes**:
   Apply the changes to create or update the resources:
   ```bash
   terraform apply
   ```

6. **Verify apply command**:
   Navigate to your AWS console and see if the bucket and DynamoDB table are created.
   **IMPORTANT NOTE:** Your state is temporarily stored in a .tfstate file locally; you need to migrate this state into the newly created bucket. PLEASE PROCEED!

7. **Migrate state**:
    Migrate the state to the newly created bucket.
    ```bash
    terraform init -migrate-state
    ```

> **Note**: Ensure that the required variables (e.g., `environment_name`) are properly defined in the `*.tfvars` files or passed as environment variables.
