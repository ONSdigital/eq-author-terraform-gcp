# Configure a local setup
- Create a project
- Enable the API's `Cloud Run`, `Firestore`, `Secrets manager`
- In the images project give Cloud Run Service Agent (`service-<project_number>@serverless-robot-prod.iam.gserviceaccount.com)` 
the followng roles
    - `Storage object viewer`
- Select Firestore native mode in the firestore console
- Create a bucket for the terraform state called `<project_id>-terraform`
- Add the following secrets in secret manager
    - `react_app_firebase_project_id`
    - `react_app_firebase_api_key`
- in either project-default or project prod rename `backend.example.tfvars` to `backend.tfvars` and update the following
    - bucket (The bucket for the state eg `<project_id>-terraform`)
- in either project-default or project prod rename `terraform.example.tfvars` to `terraform.tfvars` and update the following
    - _PROJECT_ID (Your project id)
    - _REGION (eg. `europe-west2`)
    - _DOMAIN_PREFIX (This will be put before the domain names and should not already exist, eg. `dev`)
    - _ONS_IPS (an array of ip's eg. `[/'xxx.xxx.xxx.xxx/32/", /"xxx.xxx.xxx.xxx/32/" ]`)
    - _DEV_IPS (an array of ip's eg. `[/'xxx.xxx.xxx.xxx/32/", /"xxx.xxx.xxx.xxx/32/" ]`)
- Run "gcloud auth application-default login"
- Run "gcloud config set project <project_id>"
- Run "terraform init -backend-config backend.tfvars"
- Run "terraform apply -var-file terraform.tfvars"
- After completion, add DNS records to your DNS zone using the loadbalancer IP address
    - `<domain_prefix>.author.eqbs.gcp.onsdigital.uk`
    - `<domain_prefix>.publisher.eqbs.gcp.onsdigital.uk`
    - `<domain_prefix>.validator.eqbs.gcp.onsdigital.uk`
    - `<domain_prefix>.registry.eqbs.gcp.onsdigital.uk`
    - `<domain_prefix>.author-launcher.eqbs.gcp.onsdigital.uk`
    - `<domain_prefix>.author-runner.eqbs.gcp.onsdigital.uk`
    - `<domain_prefix>.extract-questions.eqbs.gcp.onsdigital.uk`

# Configure cloud build pipeline and GCP project
- Create a project
- Enable the API's `Cloud Run`, `Firestore`, `Secrets manager`, `Cloud Build`, `service usage api`
- In the images project give Cloud Run Service Agent (`service-<project_number>@serverless-robot-prod.iam.gserviceaccount.com)` 
the followng roles
    - `Storage object viewer`
- Give Cloudbuild Account (`<project_number>@cloudbuild.gserviceaccount.com`) the following roles
    - `Editor`
    - `Project IAM Admin`
- Select Firestore native mode in the firestore console
- Add the following secrets in secret manager
    - `react_app_firebase_project_id`
    - `react_app_firebase_api_key`
- Create a bucket for the terraform state called `<project_id>-terraform`
- Create a cloud build trigger for this repo, set either cloudbuild.yaml or cloudbuild-prod.yaml for the env you want to build. Add the following environment varibles to the trigger
    - _BUCKET (The bucket to store the terraform state eg. `<project_id>-tfstate`)
    - _PREFIX (The folders path in the bucketfor the state eg. `terraform/state`) 
    - _PROJECT_ID (Your project id)
    - _REGION (eg. `europe-west2`)
    - _DOMAIN_PREFIX (This will be put before the domain names, eg. `prod`, `preprod`, `staging`)
    - _ONS_IPS (an array of ip's eg. `[/'xxx.xxx.xxx.xxx/32/", /"xxx.xxx.xxx.xxx/32/" ]`)
    - _DEV_IPS (an array of ip's eg. `[/'xxx.xxx.xxx.xxx/32/", /"xxx.xxx.xxx.xxx/32/" ]`)
- Run the trigger
- After completion, add DNS records to your DNS zone using the loadbalancer IP address
    - `<domain_prefix>.author.eqbs.gcp.onsdigital.uk`
    - `<domain_prefix>.publisher.eqbs.gcp.onsdigital.uk`
    - `<domain_prefix>.validator.eqbs.gcp.onsdigital.uk`
    - `<domain_prefix>.registry.eqbs.gcp.onsdigital.uk`
    - `<domain_prefix>.author-launcher.eqbs.gcp.onsdigital.uk`
    - `<domain_prefix>.author-runner.eqbs.gcp.onsdigital.uk`
    - `<domain_prefix>.extract-questions.eqbs.gcp.onsdigital.uk`

    additional prod domain
    - `author.eqbs.gcp.onsdigital.uk`