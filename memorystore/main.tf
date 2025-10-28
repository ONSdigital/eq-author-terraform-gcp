
module "memorystore" {
    source  = "terraform-google-modules/memorystore/google"
    version = "4.0.0"

    name                      = "author-redis"
    project                   = var.project_id
    authorized_network        = "author-vpc"
    redis_version             = "REDIS_7_2"
    memory_size_gb            = "1"
    tier                      = "BASIC"
    enable_apis               = "true"
    region                    = var.region
    transit_encryption_mode   = "DISABLED"
}