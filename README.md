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
- rename `backend.example.tfvars` to `backend.tfvars` and update the following
    - bucket (The bucket for the state eg `<project_id>-terraform`)
- rename `terraform.example.tfvars` to `terraform.tfvars` and update the following
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

# Configure cloud build pipeline and GCP project
- Create a project
- Enable the API's `Cloud Run`, `Firestore`, `Secrets manager`
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
- Create a cloud build trigger, use this repo as the source and the cloudbuild.yaml in the repo root. Add the following environment varibles to the trigger
    - _BUCKET (The bucket to store the terraform state eg. `<project_id>-tfstate`)
    - _PREFIX (The folders path in the bucketfor the state eg. `terraform/state`) 
    - _PROJECT_ID (Your project id)
    - _REGION (eg. `europe-west2`)
    - _DOMAIN_PREFIX (This will be put before the domain names, eg. `prod`, `preprod`, `staging`)
    - _ONS_IPS (an array of ip's eg. `[/'xxx.xxx.xxx.xxx/32/", /"xxx.xxx.xxx.xxx/32/" ]`)
    - _DEV_IPS (an array of ip's eg. `[/'xxx.xxx.xxx.xxx/32/", /"xxx.xxx.xxx.xxx/32/" ]`)
- Run the trigger
- After completion, add DNS records to your DNS zone using the loadbalancer IP address