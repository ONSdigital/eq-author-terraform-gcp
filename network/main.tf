
module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "10.1.1"

  project_id = var.project_id

  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "vpcaccess.googleapis.com",
  ]
}

module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 3.0"
    project_id   = var.project_id
    network_name = "author-vpc"
    routing_mode = "REGIONAL"
    subnets = [
        {
            subnet_name               = "subnet-serverless-access"
            subnet_ip                 = "10.120.16.0/28"
            subnet_region             = var.region
            subnet_flow_logs          = "true"
            subnet_flow_logs_interval = "INTERVAL_5_SEC"
            subnet_flow_logs_sampling = 0.5
            subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        }
    ]
    depends_on = [module.project-services]
}

resource "google_vpc_access_connector" "connector" {
    provider      = google-beta
    project       = var.project_id
    name          = "author-serverless-conn"
    region        = var.region
    subnet {
        name = "subnet-serverless-access"
    }
    machine_type    = "e2-micro"
    min_instances   = 2
    max_instances   = 10
    max_throughput  = 1000
    depends_on      = [module.project-services, module.vpc]
}

resource "google_compute_address" "default" {
  name       = "author-nat-external-ip"
  region     = var.region
  depends_on = [module.project-services, module.vpc]
}

module "cloud-nat" {
    source          = "terraform-google-modules/cloud-nat/google"
    version         = "~> 1.2"
    project_id      = var.project_id
    name            = "author-nat"
    region          = var.region
    network         = "author-vpc"
    nat_ips         = google_compute_address.default.*.self_link
    create_router   = "true"
    router          = "author-router"
    enable_endpoint_independent_mapping = "false"
    depends_on      = [module.vpc]
}