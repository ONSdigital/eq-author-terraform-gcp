terraform {
  backend "gcs" {}
}

provider "google" {
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
  project     = var.project_id
  region      = var.region
}

module "network" {
  source        = "./network"
  project_id    = var.project_id
  region        = var.region
}

module "memorystore" {
  source        = "./memorystore"
  project_id    = var.project_id
  region        = var.region
  depends_on  = [module.network]
}

module "applications" {
  source                        = "./applications"
  project_id                    = var.project_id
  region                        = var.region
  applications                  = local.applications
  depends_on                    = [module.network, module.memorystore]
}

module "cloud-armour" {
  source        = "./cloud-armour"
  project_id    = var.project_id
  nat_ip        = [module.network.nat_ip]
  ons_ips       = var.ons_ips
  developer_ips = var.developer_ips
  depends_on    = [module.network]
}

module "load-balancer" {
  source        = "./load-balancer"
  project_id    = var.project_id
  region        = var.region
  domains       = local.domains
  applications  = local.applications
  depends_on    = [module.cloud-armour, module.applications]
}
